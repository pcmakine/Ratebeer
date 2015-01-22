class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.map{|rating| rating.score}.inject{|sum, n| sum + n}/(ratings.length * 1.0)
  end

  def to_s
    str = " #{name} (#{brewery.name})"
  end

end

