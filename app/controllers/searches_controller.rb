class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @post = Post.new
    @word = params[:word]
    @range = params[:f]
    if @range == "post"
      @posts = Post.looks(params[:word]).visible_to(current_user).order(created_at: :desc).page(params[:page]).per(2)
    else
      @users = User.looks(params[:word]).page(params[:page]).per(2)
    end 
  end
  
end
