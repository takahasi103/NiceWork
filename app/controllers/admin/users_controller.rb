class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to admin_user_path(@user.id)
  end 
  
  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:account_name, :name, :first_name, :last_name, :email, :is_deleted)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
