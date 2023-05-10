class Public::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def create
    @post = Post.new(post_params)
    if @post.save
      if params[:post][:image].present?
        resize_image(@post.image)
      end
      redirect_to posts_path
    else
      render :new
    end
  end

  def index
    @post = Post.new
    @posts = Post.visible_to(current_user)
  end

  def show
    @user = current_user
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
    params.require(:post).permit(:user_id, :body, :image)
  end
  
  def set_post
    @post = Post.find(params[:id])
  end 
  
  #画像がある時は画像をリサイズする
  def resize_image(image)
    image_path = ActiveStorage::Blob.service.send(:path_for, image.key)
    image = MiniMagick::Image.open(image_path)
    image.resize "400x300"
    image.write image_path
  end
  
end
