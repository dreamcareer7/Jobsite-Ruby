module SendgridContacts
  extend ActiveSupport::Concern

  # prevent evaluating api key if test or env var is nil
  unless Rails.env.test? || ENV['SENDGRID_CONTACTS_API_KEY'].nil? || !ENV['DOMAIN'] == 'production'
    SG = SendGrid::API.new(api_key: ENV['SENDGRID_CONTACTS_API_KEY'])
  end

  USER_LIST = ENV["SENDGRID_CONTACTS_USER_LIST"]
  BUSINESS_LIST = ENV["SENDGRID_CONTACTS_BUSINESS_LIST"]

  def prepare_user_contact(user)
    return unless user.email.present?

    create_contact(
      JSON.parse('[{
        "first_name": "'"#{ user.first_name }"'",
        "last_name": "'"#{ user.last_name }"'",
        "city": "'"#{ (City.find(user.browse_location).name rescue "") }"'",
        "email": "'"#{ user.email }"'",
        "type": "user"
      }]')
    )

  end

  def prepare_business_contact(business)
    return unless business.email.present?

    create_contact(
      JSON.parse('[{
        "first_name": "'"#{ business.user ? business.user.first_name : '' }"'",
        "last_name": "'"#{ business.user ? business.user.last_name : '' }"'",
        "business_name": "'"#{ business.name }"'",
        "city": "'"#{ business.locations.present? ? business.locations.first.city.name : '' }"'",
        "email": "'"#{ business.email }"'",
        "type": "business"
      }]')
    )

  end


  def create_contact(contact)
    return if Rails.env.test? || ENV['SENDGRID_CONTACTS_API_KEY'].nil? || !ENV['DOMAIN'] == 'production'
    SG.client.contactdb.recipients.post(request_body: contact)
  end

  class << self

    def update_contact_lists
      user_contacts = get_all_contacts_of_type("user")
      business_contacts = get_all_contacts_of_type("business")

      SG.client.contactdb.lists._(USER_LIST).recipients.post(request_body: user_contacts)
      SG.client.contactdb.lists._(BUSINESS_LIST).recipients.post(request_body: business_contacts)
    end

    def get_all_contacts_of_type(type)
      params = JSON.parse('{"type": "'"#{ type }"'"}')
      response = SG.client.contactdb.recipients.search.get(query_params: params)

      JSON.parse(response.body)["recipients"].map{ |recipient| recipient["id"] }
    end

  end

end
