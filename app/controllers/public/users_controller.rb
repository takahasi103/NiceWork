class Public::UsersController < ApplicationController
  before_action :set_user
  
  def show
  end

  def edit
  end
  
  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end 

  def withdraw
  end
  
  private
  
  def user_params
    params.require(:user).permit(:account_name, :name, :first_name, :last_name, :email, :status)
  end
  
  def set_user
    @user = User.find_by(account_name: params[:account_name])
  end 
end
