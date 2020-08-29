#Standard subscription
Business.includes(:subscriptions).where(subscriptions: { id: nil } ).sample(30).each do |business|
  business.user.subscriptions.create(subscription_type: "standard")
end

#Premium subscription
Business.includes(:subscriptions).where(subscriptions: { id: nil } ).sample(30).each do |business|
  business.user.subscriptions.create(subscription_type: "premium")
end
