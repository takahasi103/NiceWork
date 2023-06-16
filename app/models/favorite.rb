class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post

  scope :valid_favorites, ->(user_id) do
    joins(:post)
      .where(is_cancel: false)
      .where(user_id: user_id)
  end
  
  #いいねを取り消す（理論削除）
  def unlike
    update(is_cancel: true)
  end 
  
  #いいねを再度押す
  def relike
    update(is_cancel: false)
  end 
  
end