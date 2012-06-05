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
  
  
  def  suspicious_message?(msg)
    
    #whole logic
    regexHash = { "email" => [/\b[A-Z0-9._%+-]+[@\[at\]\(at\)]+[A-Z0-9.-]+[\(dot\)\[dot\]\.]+[A-Z]{2,4}\b/i] ,
                  "phone" => [/\(?[0-9+]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}\b/i, #333 333 3333, 333-333-3333, 333.333.3333 and a '+' symbol in all combinations
                              /\(?[0-9+]{2}\)?[-. ]?[0-9]{4}[-. ]?[0-9]{4}\b/i],#33 3333 3333, 33-3333-3333, 33.3333.3333  and a '+' symbol in all combinations
                   "url" => [/((http|https):[^\s]+)/,/((www).[^\s]+)/,/([^\s]+(\.(com|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk)))/] #http://something.com, https://something.com
                }

    regexHash.each do|name,regexArray|
 
      regexArray.each do |regex|
      
        @data = msg.scan(regex)
      
        if !@data.empty?
          
          if name == 'phone'
            @data.each do |value|
              msg.sub!(value, ' [hidden phone number] ')
            end
          end
          
          if name == 'email'
            @data.each do |value|
              msg.sub!(value, ' [hidden email address] ')
            end
          end
          
          if name == 'url'
            @data.each do |value|
              msg.sub!(value[0], ' [hidden website url] ')
            end
          end
          
        end
      end
    end
    return msg
  end
end