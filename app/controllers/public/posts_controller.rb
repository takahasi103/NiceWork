class Public::PostsController < ApplicationController
  
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
  end

  def edit
  end
  
  private
  
  def post_params
    params.require(:post).permit(:user_id, :body)
  end
  
end
