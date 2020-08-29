class UpdateSendgridContactListsJob < ApplicationJob
  queue_as :default

  def perform
    SendgridContacts.update_contact_lists
  end

end


