class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      post.create_notification_comment!(current_user, comment.id)
      @post = Post.find(params[:post_id])
      @comment = Comment.new
    else
      redirect_back fallback_location: root_path, alert: "コメントの投稿に失敗しました。"
    end 
  end 
  
  def destroy
    Comment.find(params[:id]).destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end 
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end 
  
end
