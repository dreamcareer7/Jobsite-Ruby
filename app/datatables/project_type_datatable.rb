class ProjectTypeDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    @view_columns ||= {
      id: { source: "Verification.id", cond: :eq },
      name_en: { source: "ProjectType::Translation.name", cond: :like },
      name_ar: { source: "ProjectType::Translation.name", cond: :like },
      category_type: { source: "ProjectType.category_type", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        category_type: record.category_type,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    ProjectType.includes(:translations).references(:translations)
  end

end

