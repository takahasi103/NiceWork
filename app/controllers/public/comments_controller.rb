class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    #Google Natural Language APIを利用。ネガティブなコメントを検出
    if Language.contains_inappropriate_content?(comment_params[:body])
      redirect_back fallback_location: root_path, alert: "不適切なコメントの為、投稿に失敗しました。"
      return
    end
    if comment.valid?
      if comment.save
        post.create_notification_comment!(current_user, comment.id)
        @post = Post.find(params[:post_id])
        @comment = Comment.new
      else
        redirect_back fallback_location: root_path, alert: "コメントの投稿に失敗しました。"
      end
    else
      flash[:alert] = comment.errors.full_messages.join(", ")
      redirect_back fallback_location: root_path
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
