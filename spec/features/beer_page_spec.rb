require 'rails_helper'

describe "beer" do
  let!(:user) {FactoryGirl.create :user}
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
  end

  it "beer is saved when the name field is not empty" do
    beername = 'testibisse'
    fill_in('beer_name', with:beername)

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    expect(current_path).to eq(beers_path)

  end

  it "beer is not saved when no name provided" do
    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content "1 error prohibited this beer from being saved:"
    expect(page).to have_content "New beer"

    end
  end