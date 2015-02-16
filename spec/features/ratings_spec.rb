require 'rails_helper'

describe "Rating" do
  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff"}
  let!(:beer1) {FactoryGirl.create :beer, name:"iso 3", brewery:brewery}
  let!(:beer2) {FactoryGirl.create :beer, name:"Karhu", brewery:brewery}
  let!(:user) {FactoryGirl.create :user}


  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it("when given, is registered to the beer and user who is signed in") do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)

  end

  describe "Ratings to users" do
    before :each do
      @firstRatings =  [10, 20, 15, 7, 9]
      @secondRatings = [25]
      @secondUser = FactoryGirl.create :user, username:"Arto", password:"Sala1nen", password_confirmation:"Sala1nen"
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      create_beers_with_ratings(25, @secondUser)
    end

      it("ratings and the number of ratings are shown at the ratings page") do
      visit ratings_path

      expect(page).to have_content "Total number of ratings: #{@firstRatings.length + @secondRatings.length}"

      end

    it "user can see his own ratings on his own page" do
      visit user_path(user)
      @firstRatings.each do |score|
        expect(page).to have_content "anonymous #{score}"
      end
      expect(page).to have_content "Ratings"
      expect(page).to have_content "#{user.username}"

    end

    it "user can delete his ratings" do
      sign_in(username:"Arto", password:"Sala1nen")
      arto = User.find_by_username "Arto"
      visit user_path(arto)

      click_on 'delete'

      expect(page).to_not have_content "Ratings"

    end
  end
end