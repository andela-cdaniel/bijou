require "capybara/rspec"
require_relative "feature_helpers"
require_relative "todo/helper"

describe "Editing todo items", type: :feature do
  before :all do
    Capybara.app = BijouApp
  end

  before :each do
    FeatureHelpers.drop_and_regenerate_table
  end

  it "The page should have a listing of todo items with edit links" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    expect(page).to have_content("Edit")
  end

  it "The edit page should have a form with information about the selected item" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    click_link "Edit"
    expect(page).to have_content("Edit this agenda")
    expect(page).to have_selector("form")
    expect(find_field("agenda[name]").value).to eql("todo1")
    expect(page).to have_content("Mark as complete")
  end

  it "The listing page should be updated when an item is edited" do
    FeatureHelpers.populate_table_with_items(1)
    visit "/"
    expect(page).to have_content("Todo1")
    click_link "Edit"
    expect(find_field("agenda[name]").value).to eql("todo1")
    fill_in "agenda[name]", with: "Edited todo item"
    check "agenda[done]"
    click_on "Update"
    expect(page).to have_content("Edited todo item")
  end
end
