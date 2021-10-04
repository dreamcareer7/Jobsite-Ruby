module FilterServices
  extend ActiveSupport::Concern

  def filter_services
    #adapted from https://kernelgarden.wordpress.com/2014/02/26/dynamic-select-boxes-in-rails-4/

    @services = SubCategory.find(params[:sub_category_id]).services.visible.distinct

    respond_to do |format|
      format.js
    end
  end

end
