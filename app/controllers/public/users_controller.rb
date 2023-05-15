class Public::UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    @favorites = @user.favorited_posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end


  def update
    if @user.update(user_params)
      if params[:user][:profile_image].present?
        resize_profile_image(@user.profile_image)
      end
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def withdraw
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
