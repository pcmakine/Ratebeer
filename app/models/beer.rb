class Beer < ActiveRecord::Base
  include Calcs
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def to_s
    str = " #{name} (#{brewery.name})"
  end

end

