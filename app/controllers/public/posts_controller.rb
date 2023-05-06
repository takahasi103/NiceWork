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
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user)
  end 
  
  private
  
  def post_params
    params.require(:post).permit(:user_id, :body)
  end
  
end
