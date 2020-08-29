class InquiryDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      user: { source: "AdminNotification.user_email", cond: :like },
      type: { source: "AdminNotification.notification_type", cond: :eq },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        content: record.content,
        user: record.user_email,
        type: record.notification_type,
        created_at: record.created_at,
        resolved: record.resolved
      }
    end
  end

  private

  def get_raw_records
    AdminNotification.inquiries.includes(:user).references(:user)
  end

end
