class Post < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  
  has_one_attached :image
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #favoritesテーブルの指定したレコードのis_cancelの値を確認する
  def is_cancelled?(current_user, post)
    favorite = Favorite.find_by(user: user, post: post)
    favorite&.is_cancel || false
  end 
  
  #favoritesテーブルのis_cancelがfalseのいいね数をカウントする
  def count_valid_likes
    self.favorites.where(is_cancel: false).count
  end
  
  #検索方法
  def self.looks(word)
    @post = Post.where("body LIKE?", "%#{word}%")
  end 
  
end
