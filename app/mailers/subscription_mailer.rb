class SubscriptionMailer < ApplicationMailer
  include MailerHelper
  MUQAWILOON_ADDRESS = "accounts@muqawiloon.com"

  def send_receipt(subscription, target, email, address)
    @subscription = subscription
    @target = target
    @email = email
    @address = address

    setup_email({
      "-name-": [@target.name],
      "-reference_number-": [@subscription.reference_number],
      "-created_at-": [@subscription.created_at.strftime("%B %d, %Y")],
      "-payment_method-": [@subscription.payment_method],
      "-address-": [@address],
      "-subscription_type-": [@subscription.subscription_type],
      "-subscription_expiry_date-": [@subscription.expiry_date.strftime("%B %d, %Y")],
      "-amount_paid-": [@subscription.amount_paid]
    }, 'c9817cad-d0e3-41be-8a9c-d01973b47358')
    deliver_email(@email, "Receipt for Muqawiloon subscription")
    deliver_email(MUQAWILOON_ADDRESS, "Receipt for subscription: #{ @subscription.reference_number}")
  end

  def send_invoice(subscription, target, email, address)
    @subscription = subscription
    @target = target
    @email = email
    @address = address

    setup_email({
      "-name-": [@target.name],
      "-reference_number-": [@subscription.reference_number],
      "-created_at-": [@subscription.created_at.strftime("%B %d, %Y")],
      "-payment_method-": [@subscription.payment_method],
      "-address-": [@address],
      "-subscription_type-": [@subscription.subscription_type],
      "-subscription_expiry_date-": [@subscription.expiry_date.strftime("%B %d, %Y")],
      "-amount_paid-": [@subscription.amount_paid]
    }, 'ea6ed06a-5d01-4dee-8111-1c723bd77996')
    deliver_email(@email, "Invoice for Muqawiloon subscription")
    deliver_email(MUQAWILOON_ADDRESS, "Receipt for subscription: #{ @subscription.reference_number}")
  end

end
