class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
