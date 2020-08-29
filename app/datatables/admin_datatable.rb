class AdminDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Admin.id", cond: :eq },
      name: { source: "Admin.name", cond: :like },
      email: { source: "Admin.email", cond: :like },
      admin_role: { source: "Admin.role", cond: :eq },
      cities: { source: "City::Translation.name", cond: :like },
      countries: { source: "Country::Translation.name", cond: :like },
      disabled: { source: "Admin.disabled", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        email: record.email,
        admin_role: record.role.gsub("_", " "),
        cities: record.cities,
        countries: record.countries,
        disabled: record.disabled,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    Admin.includes(
      :businesses,
      countries: :translations,
      cities: :translations
    ).references(:business, :city, :country, :translation)
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
