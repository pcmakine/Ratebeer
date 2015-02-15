class Style < ActiveRecord::Base
  has_many :beers, dependent: :destroy

  def to_s
    name
  end
end
