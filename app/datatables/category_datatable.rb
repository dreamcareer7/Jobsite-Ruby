class CategoryDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Category.id", cond: :eq },
      name_en: { source: "Category::Translation.name", cond: :like },
      name_ar: { source: "Category::Translation.name", cond: :like },
      businesses: { source: "Business.count", cond: :eq },
      banner: { source: "Category::CategoryMetadata.banner", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name_en: record.name_en.present? ? record.name_en : '',
        name_ar: record.name_ar.present? ? record.name_ar : '',
        businesses: record.businesses.count,
        banner: record.category_metadata ? record.category_metadata.banner : nil,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    Category.includes(
      :translations,
      :businesses
    ).references(
      :translation,
      :category_metadata
    )
  end
end
