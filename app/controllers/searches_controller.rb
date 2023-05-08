class SearchesController < ApplicationController
  
  def search
    @word = params[:word]
    @users = User.looks(params[:word])
    @posts = Post.looks(params[:word])
  end
  
end
