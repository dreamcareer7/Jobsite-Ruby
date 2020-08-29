module Localise::UserLanguage
  extend ActiveSupport::Concern

  def current_language
    return I18n.locale = @language if @language.present?

    @language = get_language_from_cookie
    return I18n.locale = @language if @language.present?

    @language = get_language_from_browser
    if @language
      set_language_cookie(@language)
      return I18n.locale = @language
    end

    # if cookie and browser are invalid, default to English
    @language = :en
    set_language_cookie(@language)
    return I18n.locale = @language
  end

  def set_language(language)
    @language = check_language_valid(language)

    if @language.present?
      set_language_cookie(@language)
      return I18n.locale = @language
    else
      @language = :en
      set_language_cookie(@language)
      return I18n.locale = @language
    end
  end

  private

  def get_language_from_cookie
    cookie_language = cookies.signed[:language] if cookies.signed[:language].present?

    return check_language_valid(cookie_language)
  end

  def get_language_from_browser
    browser_language = request.env["HTTP_ACCEPT_LANGUAGE"]

    if browser_language.present?
      return check_language_valid(browser_language)
    else
      return false
    end
  end

  def set_language_cookie(language)
    cookies.signed[:language] = language
  end

  def check_language_valid(language)
    return false unless language.present?

    if [:en, :ar].include?(language.to_sym)
      return language
    else
      return false
    end
  end

end
