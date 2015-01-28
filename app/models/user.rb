class User < ActiveRecord::Base
  include Calcs

  validates :username, uniqueness: true,
                        length: { in: 3..15 }
  validates :password, length: { minimum: 4}
  validates :password, format: { with: /\A(.*\d.*[A-Z].*)|(.*[A-Z].*\d.*)\z/,
      message: "must include a capital letter and a digit"}

  has_secure_password

  has_many :ratings
  has_many :beers, through: :ratings
end
