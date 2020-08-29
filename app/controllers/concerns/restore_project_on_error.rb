module RestoreProjectOnError
  extend ActiveSupport::Concern

  def restore_on_validation_error
    return unless session[:restore_project].present?

    params[:project] = session[:restore_project]["project"]

    @restored = true

    #not used now that we only post to one category
    #if session[:restore_project]["project"]["required_categories"].present?
    #  @required_categories = session[:restore_project]["project"]["required_categories"].reduce(:+).split('')
    #end

    if session[:restore_project]["other_field"].present?
      @other_field = session[:restore_project]["other_field"]
    end

    begin
      @project.update_attributes(project_params)
      session.delete(:restore_project)
    rescue Paperclip::AdapterRegistry::NoHandlerError
      session.delete(:restore_project)
    end
  end

end
