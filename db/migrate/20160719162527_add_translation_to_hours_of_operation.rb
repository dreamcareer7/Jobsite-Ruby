class AddTranslationToHoursOfOperation < ActiveRecord::Migration[5.0]
  def self.up
    HoursOfOperation.create_translation_table!({
      start_day: :string,
      end_day: :string,
      start_hour: :string,
      end_hour: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    HoursOfOperation.drop_translation_table! migrate_data: true
  end
end
