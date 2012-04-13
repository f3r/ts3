module MessagesHelper
  def message_from(from)
    initials = []
    initials <<  "#{from['first_name'][0]}." if from['first_name']
    initials <<  "#{from['last_name'][0]}." if from['last_name']
    initials.join(' ')
  end

  def inquiry_user?(inquiry)
    current_user && current_user['id'] == inquiry['user_id']
  end
end