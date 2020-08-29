class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    image_url = request.env["omniauth.auth"]["info"]["image"]

    if @user.persisted?
      @user.update_attributes(fb_omniauth_info: request.env["omniauth.auth"])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?

      if image_url.present?
        @user.get_omniauth_image(image_url)
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    image_url = request.env["omniauth.auth"]["info"]["image"]

    if @user.persisted?
      @user.update_attributes(google_omniauth_info: request.env["omniauth.auth"])
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Google")

      if image_url.present?
        @user.get_omniauth_image(image_url)
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    @user = User.from_omniauth(request.env["omniauth.auth"])
    image_url = request.env["omniauth.auth"]["info"]["image"]

    if @user.persisted?
      @user.update_attributes(linkedin_omniauth_info: request.env["omniauth.auth"])
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "LinkedIn")

      if image_url.present?
        @user.get_omniauth_image(image_url)
      end
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

end
