class NewProjectDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      project: { source: "AdminNotification.project.title", cond: :like },
      user: { source: "AdminNotification.user.name", cond: :like },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.select{ |record| record.project.present? && record.user.present? }.map do |record|
      {
        id: record.id,
        project: record.project,
        user: record.user,
        created_at: record.created_at,
        resolved: record.resolved
      }
    end
  end

  private

  def get_raw_records
    AdminNotification.by_type(:new_project).includes(:user).references(:user)
  end

end
