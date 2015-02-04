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

  describe "Favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated beer if only one rating" do
      beer = FactoryGirl.create(:beer, style:"IPA")
      FactoryGirl.create(:rating, score:15, beer:beer, user:user)
      expect(user.favorite_style).to eq("IPA")

    end

    it "is the style with the highest average rating" do
      createBeersAndRatings
      expect(user.favorite_style).to eq("Porter")
    end

  end

describe "Favorite brewery" do
  let(:user){ FactoryGirl.create(:user) }

  it "has method for determining the favorite brewery" do
    expect(user).to respond_to(:favorite_brewery)
  end

  it "without ratings does not have a favorite brewery" do
    expect(user.favorite_brewery).to eq(nil)
  end

  it "is the style of the only rated beer if only one rating" do
    beer = FactoryGirl.create(:beer, style:"IPA", brewery:FactoryGirl.create(:brewery, name:"BrewDog"))
    FactoryGirl.create(:rating, score:15, beer:beer, user:user)
    expect(user.favorite_brewery).to eq("BrewDog")

  end

  it "is the style with the highest average rating" do
    createBeersAndRatings
    expect(user.favorite_brewery).to eq("Malmgard")
  end

end

end

def createBeersAndRatings
  beer1 = FactoryGirl.create(:beer, style:"Porter", brewery:FactoryGirl.create(:brewery, name:"Koff"))
  beer2 = FactoryGirl.create(:beer, style:"Porter", brewery:FactoryGirl.create(:brewery, name:"Malmgard"))
  beer3= FactoryGirl.create(:beer, style: "Weizen", brewery:FactoryGirl.create(:brewery, name:"Koff"))

  FactoryGirl.create(:rating, score:15, beer:beer1, user:user)
  FactoryGirl.create(:rating, score:30, beer:beer1, user:user)
  FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
  FactoryGirl.create(:rating, score:31, beer:beer3, user:user)
  FactoryGirl.create(:rating, score:1, beer:beer3, user:user)
end