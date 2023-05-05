class Public::UsersController < ApplicationController
  def show
    @user = User.find_by(account_name: params[:account_name])
  end

  def edit
    @user = User.find_by(account_name: params[:account_name])
  end
  
  def update
    @user = User.find_by(account_name: params[:account_name])
    @user.update(user_params)
    redirect_to user_path(@user)
  end 

  def withdraw
  end
  
  private
  
  def user_params
    params.require(:user).permit(:account_name, :name, :first_name, :last_name, :email)
  end
end
