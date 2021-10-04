module NavbarHelper
  def supplier_sub_caegory(name)
    Rails.cache.fetch("#{Rails.env}_suppliers_sub_caty_#{name}_#{I18n.locale}") {
      Category.find_by(slug: name).sub_categories.includes(:category_metadata)
              .visible.enabled.order(name: :asc).limit(28).to_a
    }
  end

  def contractor_sub_categories
    [[t("nav.consultants"), "consultants"], [t("nav.contractors"), "contractors"], [t("nav.specialists"), "specialists"], [t("nav.developers"), "municipal"]]
  end
end