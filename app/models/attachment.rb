class Attachment < ApplicationRecord

  belongs_to :owner, polymorphic: true

  belongs_to :project, -> { where(attachments: { owner_type: 'Project' }) }, foreign_key: 'owner_id'

  has_attached_file :attachment, :styles => { small: "200x200", medium: "600x300", large: "1600x400" } , default_url: "default_photos/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => [ "text/plain", "image/jpeg", "image/jpg", "image/png", "image/gif", "application/pdf", "application/xls", "application/xlsx", "application/docx", "application/docx", "application/ppt", "application/pptx", "application/msword", "application/csv", "text/csv" ]

  before_post_process :skip_docs

  scope :project_image, -> { where(owner_type: "Project") }
  scope :by_city, -> (city) { joins(:project).merge(Project.by_city(city)) }


  def is_image?
    self.attachment_content_type.starts_with?("image")
  end

  private

  def skip_docs
    ! %w( application/msword text/csv ).include?(attachment_content_type)
  end

  class << self
    def project_images
      Attachment.where(owner_type: "Project").select{ |attachment| attachment.is_image? }
    end
  end

end
