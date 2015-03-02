class RatingsController < ApplicationController
  include BackgroundWorker

  before_action :start_worker

  #the ratings are in cache. The cache is written by a background worker thread
  #The start method of the background worker is called before all the actions, and the
  #worker is started if it is not running already
  def index
    if !Rails.cache.read("ratings").nil?
      @ratings = Rails.cache.read "ratings"
    else
      @ratings = Rating.order(created_at: :desc)
    end

    if !Rails.cache.read("recent_ratings").nil?
      @recent_ratings = Rails.cache.read "recent_ratings"
    else
      @recent_ratings = Rating.order(created_at: :desc).first(5)
    end

    if !Rails.cache.read("brewery top 3").nil?
      @brewery_ratings = Rails.cache.read "brewery top 3"
    else
      @brewery_ratings  = Brewery.top(3)
    end

    if !Rails.cache.read("beer top 3").nil?
      @beer_ratings = Rails.cache.read "beer top 3"
    else
      @beer_ratings  = Beer.top(3)
    end
    if !Rails.cache.read("style top 3").nil?
      @style_ratings = Rails.cache.read "style top 3"
    else
      @style_ratings  = Style.top(3)
    end

    if !Rails.cache.read("user top 3").nil?
      @top_users= Rails.cache.read "user top 3"
    else
      @top_users  = User.top(3)
    end

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

