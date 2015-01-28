class User < ActiveRecord::Base
  include Calcs

  validates :username, uniqueness: true,
                        length: { in: 3..15 }

  has_many :ratings
end
