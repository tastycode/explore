class PostsController < ApplicationController
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to user_url(@post.recipient_id)
    else
      redirect_to user_url(@post.recipient_id)
    end
  end
  
  def index
    @posts = Post.all
  end
  
  
  private
  
  def post_params
    params.require(:post).permit(:body,:author_id,:recipient_id)
  end
end
