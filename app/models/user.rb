class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー/フォロワー一覧画面
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  #通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  
 validates :account_name, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[A-Za-z0-9]+\z/ }
 validates :name, presence: true, length: { maximum: 15 }
 validates :first_name, presence:true
 validates :last_name, presence:true
 validates :introduction, length: { maximum: 50 }
 validates :email,presence:true
  
  #user.statusがopen   → 誰でも見れる
  #             closed → フォロワーだけ見れる
  enum status: { open: 0, closed: 1 }
  
  after_update :update_post_statuses, if: :saved_change_to_status?
  
  has_one_attached :profile_image
  
  #プロフィール画像の設定
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #URLにアカウント名を表示する
  def to_param
    account_name
  end
  
  #ユーザーフルネームを表示する
  def full_name
    self.first_name + " " + self.last_name
  end
  
  #フォローした時の処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  
  #フォローを外す時の処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  
  #フォローしているか判断
  def following?(user)
    followings.include?(user)
  end
  
  #検索方法
  def self.looks(word)
    if word.present?
      @user = User.where("name LIKE ?", "%#{word}%")
    else
      @user = User.none
    end
  end
  
  #フォロー通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 0])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 0
      )
      notification.save if notification.valid?
    end
  end
  
  
  #ゲストユーザーの処理
  def self.guest
    find_or_create_by!(account_name: 'guest' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストさん"
      user.account_name = "guest"
      user.first_name = "ゲスト"
      user.last_name = "ユーザー"
      user.introduction = "よろしくお願いします!"
    end
  end
  
  private

  #ユーザー情報が更新した際に、そのユーザーのすべての投稿のpost.statusを更新する
  #user.statusがopen   → post.statusをopenに更新
  #             closed → post.statusをfollowers_onlyに更新
  def update_post_statuses
    posts.each do |post|
      if status == "closed"
        post.update(status: "followers_only")
      else
        post.update(status: status)
      end
    end
  end
  
end
