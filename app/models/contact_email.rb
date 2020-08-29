class ContactEmail

  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :from, :name, :subject, :body, :recipient, :subject_target, :number

  validates :from, :name, :number, :body, :recipient, presence: true

end
