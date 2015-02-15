class User < ActiveRecord::Base
  include Calcs

  validates :username, uniqueness: true,
                        length: { in: 3..15 }
  validates :password, length: { minimum: 4}
  validates :password, format: { with: /\A(.*\d.*[A-Z].*)|(.*[A-Z].*\d.*)\z/,
      message: "must include a capital letter and a digit"}

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    getFavoriteStyle
  end

  def favorite_brewery
    return nil if ratings.empty?
    getFavoriteBrewery
  end

  def to_s
    username
  end

  private

  def getFavoriteStyle()
    styles = Style.all
    avgmap = {}
    styles.each{|s|
      avgmap[s] = getStylesAvg s
    }
    avgmap.sort_by{ |name, score| score}.last.first
  end

  def getStylesAvg(style)
    beersThisStyle = beers.where(style_id:style.id)
    avg = 0
    beersThisStyle.each{|b|
      stylesratings = b.ratings.where(user_id:id)
      if(!stylesratings.empty?)
      avg += stylesratings.average(:score)
      end
    }
    avg
  end

  def getFavoriteBrewery()
    breweries = Brewery.all
    avgmap = {}
    breweries.each{|b|
      avg = getBreweryAvg b
      avgmap[b] = avg
    }
    favorite = avgmap.sort_by{ |brewery, score| score}.last.first
    unless favorite.nil?
      return favorite.name
    end
  end

  def getBreweryAvg(brewery)
    brewerysBeers = brewery.beers
    avg = 0
    brewerysBeers.each{|b|
      beersratings = b.ratings.where(user_id:id)
      if(!beersratings.empty?)
      avg += beersratings.average(:score)
      end
    }
    avg
  end



end
