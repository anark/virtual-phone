require "spec_helper"

feature "View existing numbers" do
  scenario "display a number" do
    FactoryGirl.create(:number, :number => "6041111111")
    visit numbers_path
    page.should have_content("604 111 1111")
  end
end

feature "Adding a number" do
  scenario "should add a number" do
    visit root_path
    first(:link, "Add New Number").click
    fill_in "Area Code", :with => "604"
    find(:select, 'number_phone_attributes_country_code').first(:option, 'Canada').select_option
    fill_in "Number", :with => "2222222222"
    click_button "Create Number"
    page.should have_content("222 222 2222")
  end
end

feature "Edit a number" do
  scenario "change forwarded to number" do
    number = FactoryGirl.create(:number, :number => "6041111111")
    visit edit_number_path(number)
    find(:select, 'number_phone_attributes_country_code').first(:option, 'Canada').select_option
    fill_in "Number", :with => "3333333333"
    click_button "Update Number"
    page.should have_content("333 333 3333")
  end
end

feature "Delete a number" do
  scenario "Delete a forwarded to number" do
    number = FactoryGirl.create(:number, :number => "6041111111")
    visit number_path number
    page.should have_content("604 111 1111")
    first(:link, "Delete Number").click
    visit numbers_path
    page.should_not have_content("604 111 1111")
  end
end
