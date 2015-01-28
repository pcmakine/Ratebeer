class BeerClub < ActiveRecord::Base
  has_many :members, -> { uniq }, through: :memberships, source: :user
  has_many :memberships

  def to_s
    name
  end
end
