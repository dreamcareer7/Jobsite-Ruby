class NewReviewDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      business: { source: "AdminNotification.business.name", cond: :like },
      user: { source: "AdminNotification.user.name", cond: :like },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.select{ |record| record.business.present? && record.user.present? }.map do |record|
      {
        id: record.id,
        business: record.business,
        user: record.user,
        created_at: record.created_at,
        resolved: record.resolved
      }
    end
  end

  private

  def get_raw_records
    AdminNotification.by_type(:new_review).includes(:business).references(:business)
  end

end
