class Public::CommentsController < ApplicationController
  
  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    comment.save
    post.create_notification_comment!(current_user, comment.id)
    @post = Post.find(params[:post_id])
    @comment = Comment.new
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
