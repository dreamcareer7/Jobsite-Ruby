require 'rails_helper'

RSpec.describe PhotoGallery, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:photo_gallery)).to be_valid
  end

  it "has an owner" do
    expect(FactoryGirl.build(:photo_gallery, owner: nil)).not_to be_valid
  end

  it "belongs to an owner" do
    photo_gallery = FactoryGirl.build_stubbed(:photo_gallery)
    expect{ photo_gallery.owner }.not_to raise_error
  end

end
