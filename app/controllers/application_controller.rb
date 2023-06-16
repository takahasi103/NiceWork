class ApplicationController < ActionController::Base
  
  def after_sign_in_path_for(resource)
      case resource
      when User
        posts_path
      when Admin
        admin_users_path
      end
  end
  
  
  def after_sign_out_path_for(resource)
      case resource
      when :user
        root_path
      when :admin
        root_path
      end
  end 
  
end