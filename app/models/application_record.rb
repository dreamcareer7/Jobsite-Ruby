class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.i18n_enum(collection, value)
    I18n.t("#{ collection }.#{ value }")
  end

  def self.i18n_enum_collection(collection)

    Hash.new.tap do |h|
      self.send(collection).keys.map do |key|
        h[I18n.t("#{ collection }.#{ key }")] = key
      end
    end

  end

end
