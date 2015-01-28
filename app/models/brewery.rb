class Brewery < ActiveRecord::Base
  include Calcs

  validates :name, presence: true
  validates  :year, numericality:{ greater_than_or_equal_to: 1042,
      only_integer: true }
  validate :cannot_be_found_in_the_future


  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def cannot_be_found_in_the_future
    if year > Time.now.year
      errors.add(:year, "cannot be in the future!")
    end
  end

  def to_s
    name
  end

end
