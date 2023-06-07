class NotificationsController < ApplicationController
   before_action :authenticate_user!
   
  def index
    @post = Post.new
    @notifications = current_user.passive_notifications
    @unread_notifications = @notifications.where.not(visitor_id: current_user.id).page(params[:page]).per(5)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
  
end
