class BusinessLogoDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Business.id", cond: :eq },
      logo: { source: "Business.updated_at", cond: :eq },
      business_name: { source: "Business::Translation.name", cond: :like},
      updated_at: { source: "Business.updated_at", cond: :like },
      cities: { source: "City::Translation.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        business_name: record.name,
        image_name: record.name,
        logo: record.logo,
        record_type: record.class.name,
        updated_at: record.updated_at,
        cities: record.cities.distinct
      }
    end
  end

  private

  def get_raw_records
    Business.has_logo.includes(
      :translations,
      :user,
      locations: { city: :translations },
    ).references(:location, :user, :city, :translation)
  end

end


