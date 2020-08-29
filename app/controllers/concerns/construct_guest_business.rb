module ConstructGuestBusiness
  extend ActiveSupport::Concern

  def construct_business(stored_business_details, user)
    business = stored_business_details["businessDetails"].delete_if{ |k, v| v.blank? }
    categories = stored_business_details["categories"].delete_if{ |k, v| v.blank? }
    location = stored_business_details["location"].delete_if{ |k, v| v.blank? }
    contact_person = stored_business_details["contact_person"].delete_if{ |k, v| v.blank? }

    constructed_business = current_user.businesses.build(business)
    constructed_business.locations.build(location)
    constructed_business.build_business_contact(contact_person)

    categories["services"].each do |service|
      constructed_business.business_services.build(service_id: service)
    end

    constructed_business.save if constructed_business.valid?

    flash[:notice] = "Business added"
    return default_profile(user)

  end

end
