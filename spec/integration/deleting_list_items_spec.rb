require "capybara/rspec"
require_relative "feature_helpers"
require_relative "todo/helper"

describe "Deleting todo items", type: :feature do
  before :all do
    Capybara.app = BijouApp
  end

  before :each do
    FeatureHelpers.drop_and_regenerate_table
  end

  it "The page should have a listing of todo items with delete links" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    expect(page).to have_content("Delete")
  end

  it "The delete page should have a form with information about the selected item" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    click_link "Delete"
    expect(page).to have_content("Delete this agenda")
    expect(page).to have_selector("form")
    expect(find_field("agenda[name]", disabled: true).value).to eql("todo1")
    expect(page).to have_content("Delete")
  end

  it "The listing page should be updated when an item is deleted" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    expect(page).to have_content("Todo1")
    click_link "Delete"
    expect(find_field("agenda[name]", disabled: true).value).to eql("todo1")
    click_on "Delete"
    expect(page).not_to have_content("Todo1")
  end
end
