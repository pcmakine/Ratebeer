class Beer < ActiveRecord::Base
  include Calcs

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  def self.top(n)
    top = Beer.all.sort_by{ |b| -(b.average_rating||0 ) }.first n
    top_beers = {}
    top.each{|b| top_beers[b] = b.average_rating}
    top_beers
  end

  def to_s
    "#{name} (#{brewery.name})"
  end

end

