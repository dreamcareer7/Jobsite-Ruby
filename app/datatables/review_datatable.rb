class ReviewDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :session
  def_delegator :@view, :current_admin

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Review.id", cond: :eq },
      comment: { source: "Review.comment", cond: :like },
      average_score: { source: "Review.average_score", cond: :like },
      review_reply: { source: "Review.review_reply", cond: :like },
      user: { source: "Review.user", cond: :like },
      business: { source: "Business.name", cond: :like },
      project: { source: "Project.title", cond: :like },
      created_at: { source: "Review.created_at", cond: :eq },
      cities: { source: "City::Translation.name", cond: :like },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        comment: ActionController::Base.helpers.truncate(record.comment, length: 140),
        average_score: record.average_score,
        review_reply: record.review_reply ? record.review_reply.body : nil,
        user: record.user,
        business: record.business,
        project: record.project,
        created_at: record.created_at,
        cities: record.business.cities,
        role: current_admin.role
      }
    end
  end

  private

  def get_raw_records
    query = Admin::ReviewPolicy::Scope.new(current_admin, Review).resolve

    query = query.includes(
      :review_reply,
      :user,
      :project,
      business: {
        locations: {
          city: :translations
        }
      }
    ).references(:review_reply, :user, :business, :project, :translation, :location, :city)

    return query if !session[:admin_country_id]

    query.joins(business: { locations: :country }).where('countries.id' => session[:admin_country_id])
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
