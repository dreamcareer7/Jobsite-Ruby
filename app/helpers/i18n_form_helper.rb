module I18nFormHelper

  def input_text_direction(locale)
    "#{ locale == :ar ? 'rtl' : 'ltr' }"
  end

end
