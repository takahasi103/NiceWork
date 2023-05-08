class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
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
  end

  def cancel
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.unlike
  end

  def apply
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.relike
  end

end
