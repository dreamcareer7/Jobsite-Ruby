class HoursOfOperation < ApplicationRecord
  belongs_to :business
  belongs_to :location

  translates :start_day, :end_day, :start_hour, :end_hour, fallbacks_for_empty_translations: true
  globalize_accessors

  enum week_period: [ :weekday, :weekend ]

end
