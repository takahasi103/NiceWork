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
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  #通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  
  #user.statusがopen   → 誰でも見れる
  #             closed → フォロワーだけ見れる
  enum status: { open: 0, closed: 1 }
  
  after_update :update_post_statuses, if: :saved_change_to_status?
  
  has_one_attached :profile_image
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #ユーザーの公開・非公開
  def open?
    status == "open"
  end

  def closed?
    status == "closed"
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
    @user = User.where("name LIKE?", "#{word}%")
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
  
  def favorited_posts
    post_ids = self.favorites.pluck(:post_id)
    Post.where(id: post_ids)
  end
  
  private

  #ユーザーステータスに連動してそのユーザーの投稿ステータスを更新する
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
