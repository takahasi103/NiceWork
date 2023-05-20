class NotificationsController < ApplicationController
  
  def index
    @post = Post.new
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
  
end
