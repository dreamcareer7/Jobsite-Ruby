class CountryDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Country.id", cond: :eq },
      name_en: { source: "Country::Translation.name", cond: :like },
      name_ar: { source: "Country::Translation.name", cond: :like },
      cities: { source: "City.count", cond: :eq },
      user_count: { source: "User.count", cond: :eq },
      business_count: { source: "Business.count", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en ? record.name_en : '',
        name_ar: record.name_ar ? record.name_ar : '',
        cities: record.cities.count,
        user_count: record.users.count,
        business_count: record.businesses.distinct.count,
        disabled: record.disabled,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    query = Admin::CountryPolicy::Scope.new(current_admin, Country).resolve

    query.includes(
      :translations,
      :cities
    ).references(:translation)

  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
