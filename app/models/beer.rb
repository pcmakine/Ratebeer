class Beer < ActiveRecord::Base
  include Calcs

  validates :name, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  def to_s
    "#{name} (#{brewery.name})"
  end

end

