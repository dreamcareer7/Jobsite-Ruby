class UserDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      name: { source: "User.name", cond: :like },
      email: { source: "User.email", cond: :like },
      location: { source: "City::Translation.name", cond: :like },
      subscription: { source: "Subscription.subscription_type", cond: :like },
      country: {source: "Location.country", cond: :like },
      projects: {source: "Project.count", cond: :like },
      lastlogin: { source: "User.last_sign_in_at", cond: :eq },
      disabled: { source: "User.disabled", cond: :eq },
      created_at: { source: "User.created_at", cond: :eq },
      subscriptions: { source: "Subscription.subscription_type", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        email: record.email,
        phone: record.mobile_number,
        subscription: record.subscriptions.last.subscription_type.capitalize,
        projects: record.projects.count,
        location: record.try(:location).try(:city).try(:name),
        lastlogin: record.try(:last_sign_in_at),
        disabled: record.disabled,
        created_at: record.created_at,
        subscriptions: record.subscriptions.pluck(:subscription_type),
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    query = User.includes(
      :subscriptions,
      location: { city: :translations }
    ).references(:location, :city, :translation, :subscription)

    return query if !session[:admin_country_id]

    query.joins(location: :country).where('countries.id' => session[:admin_country_id])
  end

end
