class Verification < ApplicationRecord

	has_many :business_verifications

  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors
end
