require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can sign with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')

      }.to change{User.count}.by(1)

    end
  end

  describe "favorite brewery and style" do
    before :each do
      sign_in(username:"Pekka", password:"Foobar1")
      click_on 'Pekka'
      @breweries =  ["Koff", "Karjala"]
      create_breweries(@breweries)
    end

    let!(:pekka) {User.find 1}
    let!(:koff) {Brewery.find 1}
    let!(:karjala) {Brewery.find 2}
    let!(:beer1) {FactoryGirl.create :beer, style:"Lager", name:"iso 3", brewery:koff}
    let!(:beer2) {FactoryGirl.create :beer, style:"Weizen", name:"Karhu", brewery:karjala}

    it "not shown if no ratings" do

      expect(page).to have_content 'Pekka'
      expect(page).to_not have_content 'Favorite brewery'
      expect(page).to_not have_content 'Favorite style'
    end

    describe "but when ratings have been made" do
      before :each do
        pekka.ratings << FactoryGirl.create(:rating, score:10, beer:beer1, user:pekka)
        pekka.ratings << FactoryGirl.create(:rating, score:50, beer:beer1, user:pekka)
        pekka.ratings << FactoryGirl.create(:rating, score:35, beer:beer2, user:pekka)
        pekka.ratings << FactoryGirl.create(:rating, score:39, beer:beer2, user:pekka)

      end
      it "correct brewery is shown" do
        click_on 'Pekka'
        expect(page).to have_content 'Pekka'
        expect(page).to have_content 'Favorite brewery: Karjala'
      end

      it "and correct style is shown" do
        click_on 'Pekka'
        expect(page).to have_content 'Pekka'
        expect(page).to have_content 'Favorite style: Weizen'
      end
    end
  end
end