class ReviewsController < ApplicationController
  
  def new
    @review = Review.new
    @review.user = User.find(params[:user_id])
  end
  
  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to user_url(@review.user_id)
    else
      redirect_to user_url(@review.user_id)
    end
  end
  
  def index
    @reviews = Review.all
  end
  
  
  private
  
  def review_params
    params.require(:review).permit(:comments,:user_id,:action_id)
  end
end
