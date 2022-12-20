json.messages_count @messages.count
json.messages @messages.each do|chat|
  json.id chat.id
  json.body chat.body
  json.subject chat.subject
  json.message_ticket chat.message_ticket
  json.conversation_id chat&.conversation_id
  json.sender_id chat&.sender_id
  json.sender_name chat&.sender&.username
  json.admin_user_id chat&.admin_user&.id
  json.admin_user_name chat&.admin_user&.admin_user_name
  json.created_at chat.created_at
  json.status chat.conversation.status
  json.message_image chat&.message_image&.attached? ? chat.message_image.blob.url : ''
  json.sender_image chat&.sender&.profile_image&.attached? ? chat.sender.profile_image.blob.url : ''
  end
