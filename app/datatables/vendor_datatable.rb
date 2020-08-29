class VendorDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      name: { source: "User.name", cond: :like },
      email: { source: "User.email", cond: :like },
      location: { source: "City::Translation.name", cond: :like },
      lastlogin: { source: "User.last_sign_in_at", cond: :eq },
      businesses: { source: "Business.count", cond: :eq },
      disabled: { source: "User.disabled", cond: :eq },
      created_at: { source: "User.created_at", cond: :eq },
    }
  end


  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        email: record.email,
        location: record.location.present? && record.location.city.present? ? record.location.city.name : nil,
        lastlogin: record.last_sign_in_at ? record.last_sign_in_at : nil,
        businesses: record.businesses.count,
        disabled: record.disabled,
        created_at: record.created_at,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    # hard join only gets users with businesses
    query = User.joins(:businesses).includes(
      :subscriptions
    ).references(:subscription)

    return query if !session[:admin_country_id]

    query.joins(location: :country).where('countries.id' => session[:admin_country_id])
  end

end
