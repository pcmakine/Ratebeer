class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validate :user_already_member

  def user_already_member
    user = User.find user_id
    clubs = user.beer_clubs
    if clubs.include? BeerClub.find beer_club_id
      errors.add(:year, "cannot join twice the same club")
    end
  end
end
