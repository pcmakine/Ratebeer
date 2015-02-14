class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def show
    places = BeermappingApi.places_in(@city)
    unless places.empty?
      @place = places.detect {|a| a.id == params[:id]}
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:cityname] = params[:city]
      render :index
    end
  end

  private

  def set_place
    @city = searched_city
  end
end