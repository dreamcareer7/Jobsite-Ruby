class AuthMailer < Devise::Mailer
  include MailerHelper
  include Devise::Controllers::UrlHelpers
  helper :application

  default from: "\"Muqawiloon\" <info@muqawiloon.com>"

  before_action :check_test

  def confirmation_instructions(record, token, opts={})
    setup_email({
      "-name-": [record.name],
      "-token-": [confirmation_url(record, confirmation_token: token, email: record.email)],
    }, '1070ebc2-d313-4334-9478-54ac5d38435f')

    deliver_email(record.email, "Please confirm your account")
  end

  def reset_password_instructions(record, token, opts={})
    setup_email({
      "-name-": [record.name],
      "-token-": [edit_password_url(record, reset_password_token: token, email: record.email)],
    }, '1dffec36-d048-44ec-afaa-8d72f7357cd4')

    deliver_email(record.email, "Password reset request")
  end

  private

  def check_test
    return if Rails.env.test?
  end

end
