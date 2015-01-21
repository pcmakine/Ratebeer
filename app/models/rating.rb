class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    str = " #{beer.name} #{score}"
  end
end
