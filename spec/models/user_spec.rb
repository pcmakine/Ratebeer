require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"
    expect(user.username).to eq("Pekka")
  end

  describe "with improper password" do
    it "not saved without password" do
      user = User.create username:"Pekka"
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end

    it "or with too short password" do
      user = User.create username:"Pekka", password:"Ab1", password_confirmation:"Ab1"
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end

    it "or with password consisting of only letters" do
      user = User.create username:"Pekka", password:"Abcdef", password_confirmation:"Abcdef"
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
end
  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

  end

  describe "Favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)

    end
  end

end
