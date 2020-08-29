class AutoCompleteController < ApplicationController
  skip_before_action :current_language
  skip_before_action :current_city
  skip_before_action :current_coordinates
  skip_before_action :current_business
  skip_before_action :limit_business_page_views

  def index
    results = AutoComplete.suggestions_for(params[:term]).map do |result|
      return if result.blank?

      result = JSON.parse(result)

      { id: result["id"],
        name: result["name"], 
        result_type: result["term_type"],
        result_sort: result["term_sort"],
        sub_category: result["sub_category"]
      }

    end

    render json: results.sort_by! { |result| result[:result_sort] }
  end

end
