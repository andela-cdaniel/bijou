require "capybara/rspec"
require_relative "todo/helper"

describe "Listing todo items", type: :feature do
  before :all do
    Capybara.app = BijouApp
  end

  after :each do
    require "pry"; binding.pry
  end

  it "" do
    visit "/"
    expect(page).to have_content("Nothing")
  end
end
