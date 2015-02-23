class RatingsController < ApplicationController
  include BackgroundWorker

  before_action :start_worker

  #the ratings are in cache. The cache is written by a background worker thread
  #The start method of the background worker is called before all the actions, and the
  #worker is started if it is not running already
  def index
    @ratings = Rails.cache.read "ratings"
    @recent_ratings = Rails.cache.read "recent_ratings"
    @brewery_ratings = Rails.cache.read "brewery top 3"
    @beer_ratings = Rails.cache.read "beer top 3"
    @style_ratings = Rails.cache.read "style top 3"
    @top_users = Rails.cache.read "user top 3"

  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice: 'You should be signed in'
    end

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end

