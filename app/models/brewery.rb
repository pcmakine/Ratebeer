class Brewery < ActiveRecord::Base
  has_many :beers

  def to_s
    name
  end
end
