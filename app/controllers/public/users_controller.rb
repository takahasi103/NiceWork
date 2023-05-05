class Public::UsersController < ApplicationController
  def show
    @user = User.find_by(account_name: params[:account_name])
  end

  def edit
  end

  def withdraw
  end
end
