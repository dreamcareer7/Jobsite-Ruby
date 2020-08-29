class QuotePolicy
  attr_reader :current_business, :quote

  def initialize(current_business, quote)
    @current_business = current_business
    @quote = quote
  end

  def new?
    current_business.standard? || current_business.premium?
  end

end
