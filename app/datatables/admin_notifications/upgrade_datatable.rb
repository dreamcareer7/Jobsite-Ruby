class UpgradeDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      content: { source: "AdminNotification.content", cond: :eq },
      user: { source: "User.name", cond: :like },
      business: { source: "Business.name", cond: :like },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      notification_type: { source: "AdminNotification.notification_type", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        resolved: record.resolved,
        content: record.content,
        user: record.user,
        business: record.business,
        created_at: record.created_at,
        type: record.notification_type
      }
    end
  end

  private

  def get_raw_records
    AdminNotification.includes(
      :business,
      :user,
    ).upgrade_requests.references(:business, :user)
  end

end

