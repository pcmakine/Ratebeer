class User < ActiveRecord::Base
  include Calcs

  validates :username, uniqueness: true,
                        length: { in: 3..15 }
  validates :password, length: { minimum: 4}
  validates :password, format: { with: /\A(.*\d.*[A-Z].*)|(.*[A-Z].*\d.*)\z/,
      message: "must include a capital letter and a digit"}

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def to_s
    username
  end

end
