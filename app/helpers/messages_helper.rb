module MessagesHelper
  def system_message_body(system_msg_id)
    t("workflow.system_msg_#{system_msg_id}".to_sym)
  end

  def conversation_title
    if @conversation.target
      "#{t("inquiries.inquiry_on")} #{@conversation.target.title}"
    else
      "#{t("inquiries.conversation_with")} #{@conversation.from.first_name}"
    end
  end

  def render_target(target, suffix)
    render("messages/target/inquiry_#{suffix}", :target => target)
  end
end