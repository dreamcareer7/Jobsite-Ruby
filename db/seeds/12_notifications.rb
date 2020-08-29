#Review notification
30.times do
  review = Review.offset(rand(Review.count)).first
  project = Project.offset(rand(Project.count)).first
  business = Business.offset(rand(Business.count)).first

  Notification.send_review(review, project, business)

end

#Quote notification
30.times do
  quote = Quote.offset(rand(Quote.count)).first
  project = Project.offset(rand(Project.count)).first
  business = Business.offset(rand(Business.count)).first

  Notification.send_quote(quote, project, business)

end

#Pending completion notification
30.times do
  project = Project.offset(rand(Project.count)).first
  business = Business.offset(rand(Business.count)).first

  Notification.send_pending_completion(project, business)

end

#Quote request notification
QuoteRequest.all.each do |quote_request|
  Notification.send_quote_request(quote_request)
end

#Callback request notification
UserCallback.all.each do |user_callback|
  Notification.send_callback_request(user_callback)
end
