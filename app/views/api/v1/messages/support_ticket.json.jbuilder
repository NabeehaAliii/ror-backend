json.message do
  json.id @message.id
  json.body @message.body
  json.conversation_id @message.conversation_id
  json.subject @message.subject.split("_").join(" ")
  json.message_ticket @message.message_ticket
  json.sender_id @message.sender_id
  json.sender_name @message.sender.username
  # json.receiver_id @message.conversation.receiver.id
  # json.receiver_name @message.conversation.receiver.username
  json.created_at @message.created_at
  json.message_image @message.message_image.attached? ? @message.message_image.blob.url : ''
  json.sender_image @message.sender.profile_image.attached? ? @message.sender.profile_image.blob.url : ''
  # json.receiver_image @message.receiver.profile_image.attached? ? @message.receiver.profile_image.blob.url : ''
  json.status @message.conversation.status
end