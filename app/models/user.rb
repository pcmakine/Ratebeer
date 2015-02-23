class User < ActiveRecord::Base
  include Calcs

  validates :username, uniqueness: true,
                        length: { in: 3..30 }
  #validates :password, length: { minimum: 4}
 # validates :password, format: { with: /\A(.*\d.*[A-Z].*)|(.*[A-Z].*\d.*)\z/,
  #    message: "must include a capital letter and a digit"}
  validate :validPassword

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def validPassword
    byebug
    if user_source == 'github'
      true
    elsif password.length < 4
      errors.add(password, "too short!")
      false
    elsif not /\A(.*\d.*[A-Z].*)|(.*[A-Z].*\d.*)\z/.match(password)
      errors.add(password, "must include a capital letter and a digit")
      false
    end
  end

  def self.top(n)
    User.all.sort_by{|u| u.ratings.count}.reverse.first n
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def to_s
    username
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item)
      }
    end
    category_ratings.sort_by{ |item| item[:rating]}.last[:item]
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category)}.uniq
  end

end
