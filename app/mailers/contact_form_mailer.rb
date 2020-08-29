class ContactFormMailer < ActionMailer::Base
  layout 'mailer'

  def new_email(email)
    @email = email

    mail(
      to: @email.recipient,
      from: "#{ @email.from }",
      subject: "#{ @email.name }: #{ @email.subject }"
    )
  end

end
