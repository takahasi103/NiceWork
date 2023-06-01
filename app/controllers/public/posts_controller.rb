class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]

  def create
    @post = Post.new(post_params)
    if params[:post][:image].present?
      image_file = params[:post][:image]
      safe_search_info = Vision.get_image_data(image_file)
      if safe_search_info['adult'] == 'LIKELY' || safe_search_info['adult'] == 'VERY_LIKELY'
        flash[:alert] = "不適切なコンテンツが検出されました。投稿はキャンセルされました。"
        redirect_to posts_path
        return
      else
        @post.save
        resize_image(@post.image)
        flash[:success] = "投稿に成功しました。"
        redirect_to posts_path
        return
      end
    end
    if @post.save
      flash[:success] = "投稿に成功しました。"
      redirect_to posts_path
    else
      redirect_back fallback_location: root_path, alert: "投稿に失敗しました。"
    end
  end

  def index
    @posts = Post.visible_to(current_user).order(created_at: :desc).page(params[:page]).per(10)
    @post = Post.new
  end

  def show
    @user = current_user
    @comment = Comment.new
  end

  def update
    if @post.update(post_params)
      if params[:post][:image].present?
        resize_image(@post.image)
      end
      flash[:success] = "編集に成功しました。"
      redirect_to post_path(@post)
    else
      redirect_back fallback_location: root_path, alert: "編集に失敗しました。"
    end
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

  #画像を投稿する時、幅400px or 高さ300pxを超える場合にリサイズする
  def resize_image(image)
    image_path = ActiveStorage::Blob.service.send(:path_for, image.key)
    image = MiniMagick::Image.open(image_path)
  
    if image.width > 400 || image.height > 300
      image.resize "400x300"
      image.write image_path
    end
  end

end
