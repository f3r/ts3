module ApplicationHelper

  def placehold(width = 60, height = 60)
    raw "<img src='http://placehold.it/#{width}x#{height}' />"
  end 

  def flash_messages
    $flash_keys ||= [:error, :notice, :warning, :alert]
    return unless messages = flash.keys.select{|k| $flash_keys.include?(k)}
    formatted_messages = messages.map do |type|      
      content_tag :div, :class => "alert-message #{type.to_s}", :style => "margin-top:10px" do
        message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end
    flash.clear # strictly clear the flash messages
    raw(formatted_messages.join)
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
      message % link_to(*item)
    else
      message % item
    end
  end

end
