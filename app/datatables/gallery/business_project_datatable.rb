class BusinessProjectDatatable < AjaxDatatablesRails::Base
  include VideoUrlHelper

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "SelfAddedProject.id", cond: :eq },
      content: { source: "SelfAddedProject.id", cond: :like },
      project_name: { source: "SelfAddedProject::Translation.title", cond: :like },
      updated_at: { source: "SelfAddedProject.updated_at", cond: :like },
      cities: { source: "City::Translation.name", cond: :like }
    }
  end

  def data
    content = []

    records.each do |record|

      next unless record.business.present?

      if record.video_link.present?

        content << {
          id: record.id,
          record_type: record.class.name,
          content_name: "video_link",
          project_name: record.title,
          business_name: record.business.name, 
          business_id: record.business.id,
          content: record.video_link,
          thumbnail: get_thumbnail(record.video_link),
          updated_at: record.updated_at,
          cities: record.business.cities.distinct
        }

      end

      next unless record.photos.present? || record.video_link.present?

      content += record.photos.map do |image|
        {
          id: record.id,
          record_type: record.class.name,
          content_name: image.name,
          project_name: record.title,
          business_name: record.business.name, 
          business_id: record.business.id,
          content: image.url(:large),
          updated_at: record.updated_at,
          cities: record.business.cities.distinct
        }
      end

    end

    return content
  end

  private

  def get_raw_records
    SelfAddedProject.has_photos.includes(
      business: [ locations: [ city: :translations] ]
    ).references(:business, :location, :city, :translation)
  end

end
