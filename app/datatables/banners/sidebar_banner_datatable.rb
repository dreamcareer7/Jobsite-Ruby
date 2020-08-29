class SidebarBannerDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Banner.title", cond: :eq },
      image_en: { source: "Banner.title", cond: :like },
      image_ar: { source: "Banner.title", cond: :like },
      banner_listings: { source: "Banner.banner_targets", cond: :like },
      banner_locations: { source: "Banner.banner_targets", cond: :like },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        image_en: record.image_en.url,
        image_ar: record.image_ar.url,
        start_date: record.start_date,
        end_date: record.end_date,
        banner_listings: record.listings.count,
        banner_locations: record.locations.count,
        role: current_admin.role,
        enabled: record.enabled
      }
    end
  end

  private

  def get_raw_records
    query = Admin::BannerPolicy::Scope.new(current_admin, Banner).resolve
    query.includes(:banner_targets).by_banner_type("side banner").references(:banner_target)
  end

end
