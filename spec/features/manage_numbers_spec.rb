require "spec_helper"

feature "View existing numbers" do
  scenario "display a number" do
    FactoryGirl.create(:number, :number => "6041111111")
    visit numbers_path
    page.should have_content("6041111111")
  end
end

feature "Adding a number" do
  scenario "should add a number" do
    visit root_path
    click_link "Add New Number"
    fill_in "Area Code", :with => "604"
    fill_in "Forward to", :with => "1234567890"
    click_button "Create Number"
    page.should have_content("1234567890")
  end
end
