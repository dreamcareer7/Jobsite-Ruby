class CertificationDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Certification.id", cond: :eq },
      logo: { source: "Certification::Translation.name", cond: :like },
      name: { source: "Certification::Translation.name", cond: :like },
      country: { source: "Country::Translation.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        logo: record.logo.url,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        role: current_admin.role,
        country: record.country ? record.country.name : ''
      }
    end
  end

  private

  def get_raw_records
    Certification.includes(:translations, country: :translations).references(:translations, :country)
  end

end
