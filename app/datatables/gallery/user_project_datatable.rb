class UserProjectDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Attachment.id", cond: :eq },
      image: { source: "Project.id", cond: :eq },
      project: { source: "Project.id", cond: :eq },
      user: { source: "Project.id", cond: :eq },
      updated_at: { source: "Project.updated_at", cond: :like },
      city: { source: "City::Translation.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        record_type: record.class.name,
        image: record.attachment,
        image_name: record.project.title,
        project: record.project,
        user: record.project.user,
        updated_at: record.project.updated_at,
        city: record.project.location.city.name
      }
    end
  end

  private

  def get_raw_records
    Attachment.includes(project: [:location, city: :translations ]).where(attachments: { owner_type: "Project" }).references(project: [ location: :city ])
  end

end

