class ServiceDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Service.id", cond: :eq },
      name_en: { source: "Service::Translation.name", cond: :like },
      name_ar: { source: "Service::Translation.name", cond: :like },
      category_id: { source: "Category.id", cond: :eq },
      category: { source: "Category::Translation.name", cond: :like },
      sub_category_id: { source: "SubCategory.id", cond: :eq },
      subcategory: { source: "SubCategory::Translation.name", cond: :like },
      businesses: { source: "Business.count", cond: :eq },
      banner: { source: "Service::CategoryMetadata.banner", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        category_id: record.category.id,
        category: record.category.name,
        sub_category_id: record.sub_category.id,
        subcategory: record.sub_category.name,
        businesses: record.businesses.count,
        banner: record.category_metadata ? record.category_metadata.banner : nil,
        disabled: record.disabled,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    Service.visible.includes(
      :translations,
      :category,
      :sub_category,
      :businesses
    ).references(:translation, :subcategory, :category, :business)
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
