require "rails_helper"

RSpec.feature "Visitor is geolocated spec" do
  scenario "They are within the distance limit of a supported city and are matched"
  scenario "They are outside the distance limit of a supported city and are prompted to choose a city"
  scenario "They choose another city from the list"
  scenario "Their city selection is stored in a cookie for later"
end
