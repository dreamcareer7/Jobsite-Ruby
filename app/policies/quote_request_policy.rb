class QuoteRequestPolicy
  attr_reader :user, :quote_request

  FREE_USER_QUOTE_REQUEST_LIMIT = 2
  FREE_USER_QUOTE_REQUEST_REFRESH = 1.month.ago

  def initialize(user, quote_request)
    @user = user
    @quote_request = quote_request
  end

  def create?
    user.pro? || (user.quote_requests.count < FREE_USER_QUOTE_REQUEST_LIMIT ||
                  user.quote_requests_pending_two_days? ||
                  user.quote_requests.last.created_at < FREE_USER_QUOTE_REQUEST_REFRESH)
  end

end
