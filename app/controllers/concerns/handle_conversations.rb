module HandleConversations
  extend ActiveSupport::Concern

  def find_conversation(user1, user2)
    Conversation.where(
      user_one_id: user1.id, 
      user_two_id: user2.id, 
      user_one_type: user1.class.name, 
      user_two_type: user2.class.name)
    .or(Conversation.where(
      user_one_id: user2.id, 
      user_two_id: user2.id, 
      user_one_type: user1.class.name, 
      user_two_type: user2.class.name)).first
  end

  def create_message_for_conversation_with_project(project, receiver, sender)
    params[:message][:project_id] = project.id
    params[:message][:receiving_user_id] = receiver.id
    params[:message][:receiving_user_type] = receiver.is_a?(Business) ? "Business" : "User"

    new_message = sender.outgoing_messages.create(message_params)

    return new_message

  end

  def create_message_for_conversation_without_project(conversation, sender)
    params[:message][:conversation_id] = conversation.id

    if conversation.user_one_id == sender.id
      params[:message][:receiving_user_id] = conversation.user_two_id
      params[:message][:receiving_user_type] = conversation.user_two_type
    else
      params[:message][:receiving_user_id] = conversation.user_one_id
      params[:message][:receiving_user_type] = conversation.user_one_type
    end

    new_message = sender.outgoing_messages.create(message_params)

    return new_message

  end

  def create_message_from_business_listing_page(business)
    params[:message][:receiving_user_id] = business.id
    params[:message][:receiving_user_type] = "Business"

    conversation = find_conversation(current_user, business)

    if conversation.present?
      params[:message][:conversation_id] = conversation.id
      new_message = current_user.outgoing_messages.create(message_params)
    else
      new_message = current_user.outgoing_messages.create(message_params)
      new_message.create_conversation(user_one_id: current_user.id, user_one_type: "User", user_two_id: business.id, user_two_type: "Business")
    end


    return new_message

  end

end
