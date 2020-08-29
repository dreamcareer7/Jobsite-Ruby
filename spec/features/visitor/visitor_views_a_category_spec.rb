require "rails_helper"

RSpec.feature "Visitor views categories" do

  scenario "They click on a category and see its sub categories" do
    category = view_category

    expect(current_path).to eq("/#{City.first.name}/categories/#{category.slug}")
    expect(page).to have_content(category.sub_categories.last.name)
  end

  def view_category
    category = FactoryGirl.create(:category, :has_sub_category)

    visit root_path

    first(:xpath, "//a[@href='/#{City.first.name}/categories/#{category.slug}']").click

    return category
  end

end
