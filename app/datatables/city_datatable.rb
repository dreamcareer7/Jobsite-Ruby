class CityDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    @view_columns ||= {
      id: { source: "City.id", cond: :eq },
      name_en: { source: "City::Translation.name", cond: :like },
      name_ar: { source: "City::Translation.name", cond: :like },
      country_id: { source: "Country.id", cond: :eq },
      country: { source: "Country::Translation.name", cond: :like },
      businesses: { source: "Business.count", cond: :eq },
      user_count: { source: "User.count", cond: :eq },
      banner: { source: "City.banner", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        country_id: record.country.id,
        country: record.country.name,
        businesses: record.businesses.count,
        user_count: record.users.count,
        banner: record.banner? ? "Yes" : "No",
        disabled: record.disabled,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    query = Admin::CityPolicy::Scope.new(current_admin, City).resolve

    query.includes(
      :translations,
      :country,
      :businesses
    ).references(:country)
  end

end
