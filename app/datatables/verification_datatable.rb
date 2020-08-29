class VerificationDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Verification.id", cond: :eq },
      name_en: { source: "Verification::Translation.name", cond: :like },
      name_ar: { source: "Verification::Translation.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    query = Verification.includes(:translations).references(:translations).order(name: :asc)

    return query if !session[:admin_country_id]

    query.joins(location: :country).where('countries.id' => session[:admin_country_id])
  end

end
