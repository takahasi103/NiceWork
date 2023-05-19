class Admin::PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]
  
  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end
  
  def destroy
    @post.destroy
    redirect_to admin_posts_path
  end 
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end 
  
end
