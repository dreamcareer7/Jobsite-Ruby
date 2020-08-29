class LanguagesController < ApplicationController
  include Localise::UserLanguage

  def set_user_language
    return unless params[:language].present?

    set_language(params[:language].to_sym)

    redirect_to :back
  end

end
