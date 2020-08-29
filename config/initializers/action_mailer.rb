ActionMailer::Base.default charset: 'utf-8'
ActionMailer::Base.smtp_settings = {
  port: 587,
  address: ENV['SMTP_HOST'],
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  domain: ENV['SMTP_DOMAIN'],
  authentication: :plain,
  enable_starttls_auto: true
}
