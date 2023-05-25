class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :destroy]
  
  def index
    redirect_to new_user_registration_path
  end 

  def show
    @post = Post.new
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def likes
    @post = Post.new
    @user = User.find_by(account_name: params[:user_account_name])
    favorites = Favorite.valid_favorites(@user)
    favorited_posts = Post.where(id: favorites.pluck(:post_id))
    @posts = favorited_posts.visible_to(current_user).order(created_at: :desc).page(params[:page]).per(5)
  end 

  def update
    if @user.update(user_params)
      if params[:user][:profile_image].present?
        resize_profile_image(@user.profile_image)
      end
      flash[:success] = "プロフィールの更新に成功しました。"
      redirect_to user_path(@user)
    else
      redirect_back fallback_location: user_path(@user), alert: "プロフィールの更新に失敗しました。"
    end
  end
  
  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:account_name, :name, :first_name, :last_name, :introduction, :email, :status, :profile_image)
  end

  def set_user
    @user = User.find_by(account_name: params[:account_name])
  end

  #プロフィール画像がある時は画像をリサイズする
  def resize_profile_image(profile_image)
    profile_image_path = ActiveStorage::Blob.service.send(:path_for, profile_image.key)
    profile_image = MiniMagick::Image.open(profile_image_path)
    profile_image.resize "100x100"
    profile_image.write profile_image_path
  end

end
