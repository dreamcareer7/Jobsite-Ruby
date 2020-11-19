class Attachment < ApplicationRecord

  belongs_to :owner, polymorphic: true

  belongs_to :project, -> { where(attachments: { owner_type: 'Project' }) }, foreign_key: 'owner_id'
  belongs_to :message, -> { where(attachments: { owner_type: 'Message' }) }, foreign_key: 'owner_id'

  #has_attached_file :attachment, :styles => { small: "200x200", medium: "600x300", large: "1600x400" } , default_url: "default_photos/:style/missing.png"
  #validates_attachment_content_type :attachment, :content_type => [ "text/plain", "image/jpeg", "image/jpg", "image/png", "image/gif", "application/pdf", "application/xls", "application/xlsx", "application/docx", "application/docx", "application/ppt", "application/pptx", "application/msword", "application/csv", "text/csv",  'application/mp3', 'application/x-mp3', 'audio/mpeg','audio/mp3' ]

  scope :project_image, -> { where(owner_type: "Project") }
  scope :by_city, -> (city) { joins(:project).merge(Project.by_city(city)) }
  
  # Apply styling appropriate for this file
  has_attached_file :attachment, styles: lambda { |a| a.instance.check_file_type}, :default_url => "no_image.png"
  validates_attachment_content_type :attachment, :content_type => [ "text/plain", "image/jpeg", "image/jpg", "image/png", "image/gif", "application/pdf", "application/xls", "application/xlsx", "application/docx", "application/docx", "application/ppt", "application/pptx", "application/msword", "application/csv", "text/csv",  'application/mp3', 'application/x-mp3', 'audio/mpeg','audio/mp3', 'video/mp4' ]

  before_post_process :skip_docs

  # The path of the image that will be shown while the file is loading
  def processing_image_path(image_name)
    "/assets/" + Rails.application.assets.find_asset(image_name).digest_path
  end    

  def check_file_type
    if is_image_type?
      {:large => "750x750>", :medium => "300x300#", :thumb => "100x100#" }
    elsif is_video_type?
      {
          :medium => { :geometry => "300x300#", :format => 'jpg'},
          :video => {:geometry => "640x360#", :format => 'mp4', :processors => [:ffmpeg]}
      }
    elsif is_audio_type?
      {
        :audio => {
          :format => "mp3", :processors => [:ffmpeg]
        }
      }
    else
      {}
    end
  end
    
  # Method returns true if file's content type contains word 'image', overwise false
  def is_image_type?
    attachment_content_type =~ %r(image)
  end

  # Method returns true if file's content type contains word 'video', overwise false
  def is_video_type?
    attachment_content_type =~ %r(video)
  end

  # Method returns true if file's content type contains word 'audio', overwise false
  def is_audio_type?
    attachment_content_type =~ /\Aaudio\/.*\Z/
  end

  # def is_image?
  #   self.attachment_content_type.starts_with?("image")
  # end

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
