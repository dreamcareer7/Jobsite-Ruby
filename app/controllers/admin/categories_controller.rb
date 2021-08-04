class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize Category

    respond_to do |format|
      format.html
      format.json { render json: CategoryDatatable.new(view_context) }
    end
  end

  def show
    authorize @category
    redirect_to index
  end

  def new
    authorize Category
  end

  def edit
    authorize @category
    @category.build_category_metadata if @category.category_metadata.blank?
  end

  def update
    authorize @category

    @category.build_category_metadata if @category.category_metadata.blank?
    if @category.update_attributes(category_params)
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @category
    @category.destroy
    redirect_back(fallback_location: admin_categories_path)
  end

  protected

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def policy(record)
    Admin::CategoryPolicy.new(current_admin, record)
  end

  def category_params
    params.require(:category).permit(
      :id,
      :name,
      :name_en,
      :name_ar,
      :category_metadata_attributes =>[
        :id,
        :subheadline_en,
        :subheadline_ar,
        :description_en,
        :description_ar,
        :banner
      ]
    )
  end

end
