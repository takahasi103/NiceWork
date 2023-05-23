class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @post = Post.new
    @word = params[:word]
    @users = User.looks(params[:word]).page(params[:page]).per(10)
  end
  
end
