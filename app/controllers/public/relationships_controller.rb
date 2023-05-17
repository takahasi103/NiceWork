class Public::RelationshipsController < ApplicationController

  before_action :set_user

  #フォローする
  def create
    current_user.follow(@user)
    @user.create_notification_follow!(current_user)
    redirect_to request.referer
  end

  #フォローを外す
  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  #フォロー一覧
  def followings
    user = User.find(@user.id)
    @users = user.followings.page(params[:page]).per(10)
  end

  #フォロワー一覧
  def followers
    user = User.find(@user.id)
    @users = user.followers.page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find_by(account_name: params[:user_account_name])
  end

end
