class Brewery < ActiveRecord::Base
  include Calcs

  validates :name, presence: true
  validates  :year, numericality:{ greater_than_or_equal_to: 1042,
      only_integer: true }
  validate :cannot_be_found_in_the_future

  scope :active, -> {where active:true}
  scope :retired, -> {where active:[nil, false]}


  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def cannot_be_found_in_the_future
    if year > Time.now.year
      errors.add(:year, "cannot be in the future!")
    end
  end

  def self.top(n)
    sql = "select avg(r.score) as avg, b.brewery_id from ratings r join beers b on r.beer_id = b.id group by b.brewery_id order by avg desc limit #{n}"
    top = ActiveRecord::Base.connection.execute(sql)
    top_breweries = {}
    top.each{|b| top_breweries[Brewery.find(b["brewery_id"])] = b["avg"]}
    top_breweries
  end

  def to_s
    name
  end

end
