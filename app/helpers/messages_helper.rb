module MessagesHelper
  def message_from(from)
    initials = []
    initials <<  "#{from['first_name'][0]}." if from['first_name']
    initials <<  "#{from['last_name'][0]}." if from['last_name']
    initials.join(' ')
  end

  def system_message_body(system_msg_id)
    t("workflow_system_msg_#{system_msg_id}".to_sym)
  end

  def conversation_title
    if @inquiry
      "#{t(:inquiry_on)} #{@inquiry['place_title']}"
    else
      "#{t(:conversation_with)} #{@conversation['from']['first_name']}"
    end
  end
end