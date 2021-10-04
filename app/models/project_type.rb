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

    def appropriate_project_types(category)
      return '' unless category.present?

      if I18n.with_locale(:en){ category.name } == 'Machinery'
        self.by_category_type(:machinery).order(:name)
      elsif I18n.with_locale(:en){ category.name } == 'Suppliers'
        self.by_category_type(:supplier).order(:name)
      else
        self.by_category_type(:professional).order(:name)
      end
    end

    def blurb(category_type)
      I18n.t("project_type.#{ category_type }.blurb")
    end

  end
end
