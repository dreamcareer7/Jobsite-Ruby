class DatePickerFutureInput < SimpleForm::Inputs::StringInput 
  def input                    
    value = input_html_options[:value]
    value ||= object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes << "datepicker-future field__input"
    super
  end
end

