require 'rails_helper'

RSpec.describe Brewery, type: :model do

describe "when initialized with name Schlenkerla and year 1674" do
  BeerClub
  BeerClubsController
  MembershipsController

  subject {Brewery.create name:"Schlenkerla", year:1674}

    its(:name) {should eq("Schlenkerla")}
    its(:year) {should eq(1674)}
    it {should be_valid}
end
  it "without a name is not valid" do
    brewery = Brewery.create year:1674

    expect(brewery).not_to be_valid
  end
end
