class AddContactInfoToTeamMember < ActiveRecord::Migration[5.0]
  def change
    change_table :team_members do |t|
      t.string :phone_number
      t.string :email
    end
  end
end
