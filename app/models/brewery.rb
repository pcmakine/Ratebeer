class Brewery < ActiveRecord::Base
  include Calcs

  validates :name, presence: true
  validates  :year, numericality:{ greater_than_or_equal_to: 1042,
      less_than_or_equal_to: 2015,
      only_integer: true }


  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

end
