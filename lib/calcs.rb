module Calcs
  def average_rating
    ratings.map{|rating| rating.score}.inject{|sum, n| sum + n}/(ratings.length * 1.0)
  end
end