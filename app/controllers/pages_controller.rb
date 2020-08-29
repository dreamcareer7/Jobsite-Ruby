class PagesController < ApplicationController
  def show
    if params[:page] == "contact"
      @email = ContactEmail.new
    end

    render template: "pages/#{params[:page]}"
  end
end
