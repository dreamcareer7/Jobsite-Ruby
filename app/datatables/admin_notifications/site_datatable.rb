class SiteDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      content: { source: "AdminNotification.content", cond: :eq },
      user: { source: "User.name", cond: :like },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.map do |record|
      next unless record.present? && record.id.present?
      {
        id: record.id,
        content: record.content,
        notification: record.notification_type,
        resolved: record.resolved,
        user: record.user,
        business: record.business,
        created_at: record.created_at
      }
    end
  end

  private

  def get_raw_records
    AdminNotification.includes(
      :business,
      :user,
    ).site_notifications.references(:business, :user)
  end

end

