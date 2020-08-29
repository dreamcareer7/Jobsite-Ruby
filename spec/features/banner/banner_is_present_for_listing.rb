require "rails_helper"

RSpec.feature "A banner is shown for a listing" do

  scenario "A user visits a listing that has a banner associated with it and sees the banner" do
    FactoryGirl.create(:sub_category)
    banner = FactoryGirl.create(:banner)

    visit(sub_category_path(id: SubCategory.first))

    expect(page).to have_content(banner.link_en)

  end

end


