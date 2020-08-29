class AddProfileImageToTeamMembers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :team_members, :profile_image
  end
end
