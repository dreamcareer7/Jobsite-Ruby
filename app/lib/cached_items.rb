class CachedItems

    def self.all_categories

        Rails.cache.fetch("#{Rails.env}_all_categories"){
          Category.order(created_at: :asc)
        }
      end


      def self.spec_cat
        Rails.cache.fetch("#{Rails.env}_spec_cat_new"){
        Category.where(name: "Specialists").first
        }
      end


      def self.popular_items(city)
        Rails.cache.fetch("#{Rails.env}_popular_items_new_#{city.id}"){
        SubCategory.visible.includes(:category_metadata).popular_by_listing_count(city).first(4).to_a
        }
      end


end