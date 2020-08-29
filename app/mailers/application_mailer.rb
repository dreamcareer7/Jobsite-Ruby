class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: "\"Muqawiloon\" <info@muqawiloon.com>"
  include ActionView::Helpers::NumberHelper

  before_action :check_test

  private

  def check_test
    return if Rails.env.test?
  end

end
