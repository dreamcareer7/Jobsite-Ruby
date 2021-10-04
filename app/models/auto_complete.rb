class AutoComplete
  @redis = Redis.new
  MAX_RESULTS = 10

  def self.suggestions_for(term)
    results = []
    count = 0

    @redis.scan_each(match: "*#{ term.downcase }*") do |key|
      break if count >= MAX_RESULTS

      if !results.include? @redis.get(key)
        results << begin @redis.get(key) rescue next end
        count += 1
      end
    end

    results
  end

  def self.index_target_terms
    recordSetsToIndex = [
      Category.with_translations.distinct,
      SubCategory.with_translations.visible.enabled.distinct,
      Service.with_translations.includes(sub_category: :translations).visible.enabled.distinct,
      Business.with_translations.active.distinct
    ]

    self.flush_redis

    count = 0
    s = Time.now

    recordSetsToIndex.each do |record_set|
      record_set.find_each do |record|

        record.translations.each do |translation|
          index_object(record, count, translation.locale)
          count += 1
        end

      end
    end

    f = Time.now

    puts "Took #{ f - s } to index #{ count } items"
  end

  def self.index_object(term, count, locale)
    term.class.name == "Business" ? term_sort = "Business" : term_sort = "Category"
    term.class.name == "SubCategory" ? 
      term_type = "sub_categories" : 
      term_type = term.class.name.downcase.pluralize

    @redis.set("#{ I18n.with_locale(locale){ term.name.downcase } }#{ count }", 
               generate_term_hash(term, term_sort, term_type, locale).to_json)
  end

  def self.generate_term_hash(term, term_sort, term_type, locale)
    term_hash = {
      id: term.slug,
      name: I18n.with_locale(locale){ term.name },
      term_sort: term_sort,
      term_type: term_type,
    }

    if term_type == "services"
      term_hash[:sub_category] = I18n.with_locale(locale){ term.sub_category.name } 
      term_hash
    else
      term_hash
    end
  end

  def self.flush_redis
    @redis.flushall
  end

end
