class Admin::SubCategoriesController < Admin::BaseController
  before_action :set_sub_category, only: [:destroy, :update, :edit, :enable, :disable]
  after_action :verify_authorized

  def index
    authorize SubCategory

    respond_to do |format|
      format.html do
        @category = Category.find(params[:category_id]) if params[:category_id]
      end

      format.json { render json: SubCategoryDatatable.new(view_context) }
    end
  end

  def show
    authorize SubCategory
    redirect_to admin_categories_path
  end

  def new
    authorize SubCategory

  	@subcategory = SubCategory.new
    @category = Category.find(params[:category_id])
    @subcategory.build_category_metadata if @subcategory.category_metadata.blank?
  end

  def create
    authorize SubCategory

	  @subcategory = SubCategory.includes(:category_metadata).create( sub_category_params )
    redirect_to admin_sub_categories_path(category_id: @subcategory.category.id)
  end

  def edit
    authorize @subcategory

    @category = @subcategory.category
    @subcategory.build_category_metadata if @subcategory.category_metadata.blank?
    params[:category] = @subcategory.category_id
  end

  def update
    authorize @subcategory

    @category = @subcategory.category
    @subcategory.build_category_metadata if @subcategory.category_metadata.blank?

    if @subcategory.update_attributes(sub_category_params)
      redirect_to admin_sub_categories_path(category_id: @subcategory.category.id)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @subcategory
    category_id = @subcategory.category_id
    @subcategory.destroy
    redirect_to admin_sub_categories_path(category_id: category_id)
  end

  def disable
    authorize @subcategory

    @subcategory.update(disabled: true)
    redirect_back(fallback_location: admin_sub_categories_path)
  end

  def enable
    authorize @subcategory

    @subcategory.update(disabled: false)
    redirect_back(fallback_location: admin_sub_categories_path)
  end


  protected

  def set_sub_category
    @subcategory = SubCategory.friendly.find(params[:id])
  end

  def policy(record)
    Admin::SubCategoryPolicy.new(current_admin, record)
  end

  def sub_category_params
    params.require(:sub_category).permit(
      :name_en,
      :name_ar,
      :category_id,
      :category_metadata_attributes =>[
        :subheadline_en,
        :subheadline_ar,
        :banner
      ]
    )
  end

end
