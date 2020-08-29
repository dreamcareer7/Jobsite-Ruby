class BusinessDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Business.id", cond: :eq },
      name: { source: "Business::Translation.name", cond: :like },
      cities: { source: "City::Translation.name", cond: :like },
      categories: { source: "Category::Translation.name", cond: :like },
      user: { source: "Business.user", cond: :like },
      updated_at: { source: "Business.updated_at", cond: :like },
      created_at: { source: "Business.created_at", cond: :like },
      disabled: { source: "Business.disabled", cond: :eq },
      approved: { source: "Business.approved", cond: :eq },
      flagged: { source: "Business.flagged", cond: :eq },
      subscriptions: { source: "Subscription.subscription_type", cond: :like },
      verified: { source: "Business.verified", cond: :eq },
      role: { source: "Admin.role", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        cities: record.cities.distinct,
        categories: record.categories.distinct,
        user: record.user,
        updated_at: record.updated_at,
        created_at: record.created_at,
        disabled: record.disabled?,
        approved: record.approved?,
        paid: record.paid_user?,
        flagged: record.flagged?,
        subscriptions: subscription_name(record),
        verified: record.verified?,
        role: current_admin.role
      }
    end
  end

  def subscription_name(business)
    if business.subscriptions.valid.any?
      "Verified #{ business.subscriptions.last.subscription_type }"
    elsif business.user.present?
      "Verified Free"
    else
      "Free"
    end
  end

  private

  def get_raw_records
    query = Admin::BusinessPolicy::Scope.new(current_admin, Business).resolve

    query = query.includes(
      :translations,
      :user,
      :subscriptions,
      locations: { city: :translations },
      categories: :translations
    ).references(:location, :city, :translation, :category, :user, :subscription)

    return query if !session[:admin_country_id]

    query = query.joins(locations: :country).where('countries.id' => session[:admin_country_id])
  end

end
