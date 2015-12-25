require "capybara/rspec"
require_relative "feature_helpers"
require_relative "todo/helper"

describe "Creating and listing todo items", type: :feature do
  before :all do
    Capybara.app = BijouApp
  end

  describe "Listing todo items" do
    context "When the todo list is empty" do
      it "Shows a message informing the user that
          there is no item in the todo yet" do
        FeatureHelpers.drop_and_regenerate_table
        visit "/"
        expect(page).to have_content(
          "Sorry, you do not have any agenda created yet. Create a new
           agenda with the link above."
        )
      end
    end

    context "When the todo list contains items" do
      it "Lists the todo items" do
        FeatureHelpers.populate_table_with_items(1)
        visit "/"
        expect(page).to have_content("Todo1")
        FeatureHelpers.drop_and_regenerate_table
      end
    end
  end

  describe "Creating todo items" do
    it "Displays a form that enables the user to create a todo item" do
      visit "/"
      expect(page).to have_content("My Agenda")
      click_link "Create a new agenda"
      expect(page).to have_content("Create a new Agenda")
      expect(page).to have_selector("form")
      expect(page).to have_selector("input#agenda_name")
      FeatureHelpers.drop_and_regenerate_table
    end

    it "Creates a new todo item when the form is submitted" do
      visit "/"
      expect(page).to have_content("My Agenda")
      click_link "Create a new agenda"
      fill_in "agenda[name]", with: "Testing app"
      click_on "Create"
      expect(page).to have_content("Testing app")
      FeatureHelpers.drop_and_regenerate_table
    end

    it "The page should have a button that links back to the homepage" do
      visit "/agenda/new"
      expect(page).to have_content("Back to homepage")
      click_link "Back to homepage"
      expect(page).to have_content("My Agenda")
    end
  end
end
