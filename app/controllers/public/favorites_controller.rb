class Public::FavoritesController < ApplicationController
  before_action :set_post

  def create
    favorite = current_user.favorites.new(post_id: @post.id)
    if favorite.save
      current_user.increment!(:experience_point, 25)
      level = current_user.level
      threshold = LevelSetting.find_by(level: level + 1).threshold
      if current_user.experience_point >= threshold
        current_user.increment(:level, + 1)
        current_user.update(experience_point: 0)
      end
    end 
    @post.create_notification_favorite!(current_user)
  end

  def cancel
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.unlike
  end

  def apply
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.relike
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end 

end
