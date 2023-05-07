class Public::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to posts_path
  end

  def index
    @post = Post.new
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def edit
  end
  
  def update
    @post.update(post_params)
    redirect_to post_path(@post)
  end
  
  def destroy
    @post.destroy
    redirect_to user_path(current_user)
  end 
  
  private
  
  def post_params
    params.require(:post).permit(:user_id, :body)
  end
  
  def set_post
    @post = Post.find(params[:id])
  end 
  
end
