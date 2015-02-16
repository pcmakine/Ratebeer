class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.order(created_at: :desc).first 5

    @brewery_ratings = Brewery.top(3)
    @top_breweries = @brewery_ratings.keys

    @beer_ratings = Beer.top(3)
    @top_beers = @beer_ratings.keys

    @style_ratings = Style.top(3)
    @top_styles = @style_ratings.keys

    @top_users = User.top(3)

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

