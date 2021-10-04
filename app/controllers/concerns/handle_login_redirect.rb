module HandleLoginRedirect
  extend ActiveSupport::Concern
  include ConstructGuestBusiness

  def handle_login_target(user)
    return if !cookies[:loginTarget]

    login_target = cookies[:loginTarget]
    business = cookies[:loginTargetBusiness]
    redirect = cookies[:loginRedirect]

    cookies.delete(:loginTarget)
    cookies.delete(:loginRedirect)
    cookies.delete(:loginTargetBusiness)

    #in concerns/construct_guest_business
    construct_business(JSON.parse(login_target), user) if login_target.include?('businessDetails')

    case login_target
    when "project"
      return new_user_project_path
    when "business"
      return new_user_business_path
    when "invite", "message", "callback", "claim"
      return back_to_business(login_target, business, user)
    when "follow"
      return back_to_business('', business, user) if business.present?

      return redirect if redirect.present?

      return default_profile(user)

    when "problem"
      return back_to_business(login_target, business, user) if business.present?

      return redirect + "?target=problem" if redirect.present?

      return default_profile(user)

    else
      return default_profile(user)
    end
  end

  def back_to_business(target_type, business, user)
    business = Business.friendly.find(business)
    return default_profile(user) unless business.present?

    business_path(id: business.slug, target: target_type, city: @current_city.slug)
  rescue ActiveRecord::RecordNotFound
    default_profile(user)
  end

  def default_profile(user)

    if user.required_fields_present?
      return user_profile_index_path unless user.default_profile != user.id
    else
      return edit_user_path(user)
    end

    begin
      Business.find(user.default_profile)
    rescue ActiveRecord::RecordNotFound
      user.update_attributes(default_profile: user.id)

      return after_sign_in_path_for(user)
    end

    business_profile_index_path(business: user.default_profile)
  end

end
