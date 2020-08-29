module MailerHelper

  def setup_email(substitutions, template_id)

    headers "X-SMTPAPI" => {
      "sub": substitutions,
      "filters": {
        "templates": { "settings": { "enable": 1, "template_id": template_id } }
      }
    }.to_json

  end

  def deliver_email(recipient, subject)

    mail(
      to: recipient,
      subject: subject,
      body: "",
      content_type: "text/html"
    )

  end

end
