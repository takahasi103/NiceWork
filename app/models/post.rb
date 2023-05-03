class Post < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  
  has_one_attached :image
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
