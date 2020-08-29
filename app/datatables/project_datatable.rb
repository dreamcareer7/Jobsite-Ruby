class ProjectDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Project.id", cond: :eq },
      title: { source: "Project::Translation.title", cond: :like },
      status: { source: "Project.project_status", cond: :eq },
      category: { source: "Category::Translation.name", cond: :like },
      city: { source: "City::Translation.name", cond: :like },
      user: { source: "User.name", cond: :like },
      business: { source: "Business.name", cond: :like },
      approved: { source: "Project.approved", cond: :eq },
      created_at: { source: "Project.created_at", cond: :like },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        title: record.title,
        city: record.city ? record.city.name : '',
        category: record.category,
        status: { name: record.status_to_s, project_status: record.project_status },
        approved: record.approved,
        user: record.user ? record.user : '',
        business: record.business ? record.business : nil,
        role: current_admin.role,
        created_at: record.created_at
      }
    end
  end

  private

  def get_raw_records
    #query = Admin::CountryPolicy::Scope.new(current_admin, Country).resolve
    query = Project.all

    query.joins(:user).includes(
      :category,
      :translations,
      :business,
      location: { city: :translations },
    ).references(:translation, :location, :city, :user, :business, :category)

  end

end

