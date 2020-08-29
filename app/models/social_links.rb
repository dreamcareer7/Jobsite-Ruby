class SocialLinks < ApplicationRecord

  validates :owner, presence: true

  belongs_to :owner, polymorphic: true

  def profiles
    profile_list = { facebook: self.facebook, 
      twitter:  self.twitter, 
      linkedin: self.linkedin, 
      youtube:  self.youtube, 
      instagram: self.instagram, 
      google_plus: self.google_plus,
      prequalification: self.prequalification }

    profile_list.delete_if { |k, v| v.nil? || v.empty? }
  end

end
