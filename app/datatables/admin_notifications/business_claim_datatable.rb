class BusinessClaimDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "AdminNotification.id", cond: :eq },
      content: { source: "AdminNotification.content", cond: :eq },
      user: { source: "User.name", cond: :like },
      business: { source: "Business.name", cond: :like },
      created_at: { source: "AdminNotification.created_at", cond: :eq },
      resolved: { source: "AdminNotification.resolved", cond: :eq }
    }
  end

  def data
    records.select{ |record| record.business.present? && record.user.present? }.map do |record|
      {
        id: record.id,
        resolved: record.resolved,
        content: record.content,
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
    ).business_claims.references(:business, :user)
  end

end
