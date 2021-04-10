class ProjectType < ApplicationRecord
  belongs_to :business
  belongs_to :project

  translates :name
  globalize_accessors

  scope :by_category_type, -> (category_type) { where(category_type: category_type).order(name: :asc) }

  enum category_type: [
    :professional,
    :supplier,
    :machinery
  ]

  class << self
    def cached_appropriate_project_types(category_id)
      ##TODO: fix caching here depends on name 
      return '' unless category_id.present?
      @category = Category.find_by_id(category_id)
      return '' if @category.nil?
      Rails.cache.fetch("#{Rails.env}_cached__by_n_category_type_#{category_id}_#{I18n.locale}"){
      if I18n.with_locale(:en){ @category.name } == 'Machinery'
        where(category_type: "machinery").order(name: :asc).to_a
        #self.by_category_type(:machinery).order(:name).to_a
      elsif I18n.with_locale(:en){ @category.name } == 'Suppliers'
        where(category_type: "supplier").order(name: :asc).to_a
        #self.by_category_type(:supplier).order(:name).to_a
      else
        where(category_type: "professional").order(name: :asc).to_a
        #self.by_category_type(:professional).order(:name).to_a
      end
    }

    end


    def appropriate_project_types(category)
      ##TODO: fix caching here depends on name 
      return '' unless category.present?
      Rails.cache.fetch("#{Rails.env}_cached_by_category_type_#{category.id}_#{I18n.locale}"){
      if I18n.with_locale(:en){ category.name } == 'Machinery'
        self.by_category_type(:machinery).order(:name)
      elsif I18n.with_locale(:en){ category.name } == 'Suppliers'
        self.by_category_type(:supplier).order(:name)
      else
        self.by_category_type(:professional).order(:name)
      end
    }

    end


  

    def blurb(category_type)
      I18n.t("project_type.#{ category_type }.blurb")
    end

  end
end
