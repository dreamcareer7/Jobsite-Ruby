module Listing::Filter
  extend ActiveSupport::Concern
  include SortBusinesses

  FILTER_TERMS = ["Recommended", "Latest", "Distance", "Verified"]

  DEFAULT_FILTER = 'Recommended'

  def handle_filter(businesses)
    if params[:filter_by].present?
      sorted_businesses = handle_sorting(businesses, params[:filter_by]) || []
    else
      sorted_businesses = handle_sorting(businesses, DEFAULT_FILTER) || []
    end

    Kaminari.paginate_array(sorted_businesses).page(params[:page]).per(10)
  end

  def set_filter_terms
    @filter_terms = FILTER_TERMS
  end
end

