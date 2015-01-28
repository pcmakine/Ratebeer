module Calcs
  def average_rating
    return 0 if ratings.empty?
    ratings.map{|rating| rating.score}.sum/(ratings.count * 1.0)
  end
end