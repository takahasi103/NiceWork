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
  
  has_one_attached :profile_image
  
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
    @user = User.where("name LIKE?", "#{word}%")
  end 
  
end
