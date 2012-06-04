module ApplicationHelper
  def placehold(width = 60, height = 60, url = false)
    if url
      "http://placehold.it/#{width}x#{height}"
    else
      raw "<img src='http://placehold.it/#{width}x#{height}' />"
    end
  end

  def flash_messages
    $flash_keys ||= [:error, :success, :notice, :warning, :alert]
    return unless messages = flash.keys.select{|k| $flash_keys.include?(k)}

    formatted_messages = messages.map do |type|
      content_tag :div, :class => "alert alert-#{type.to_s}", :style => "margin-top:25px" do
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

  def time_array
    [t("flexible"), "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM", "08:00 PM", "08:30 PM", "09:00 PM", "09:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM", "12:00 AM", "12:30 AM", "01:00 AM", "01:30 AM", "02:00 AM", "02:30 AM", "03:00 AM", "03:30 AM", "04:00 AM", "04:30 AM", "05:00 AM", "05:30 AM", "06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM", "08:00 AM", "08:30 AM", "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"]
  end

  def coded_errors_for(model)
    ret = ''

    if model.errors.any?


      msgs = []
      model.errors.full_messages.each do |errs|
        msgs << error_codes_to_messages(errs)
      end
      msgs.flatten!

      ret = "<h5>#{pluralize(msgs.size, 'error')} prohibited this to save.</h5>"
      ret << '<ul class="coded_error">'

      msgs.each do |msg|
        ret << "<li>#{msg}</li>"
      end

      ret << '</ul>'
    end

    raw ret
  end

  def message_count
    status = Messenger.inbox_status(current_user)
    status[:unread]
  end

  def large_avatar(user)
    if user.avatar?
      user.avatar.url(:thumb)
    else
      "https://s3.amazonaws.com/squarestays-static/missing_userpic_200.jpeg"
    end
  end

  def require_google_apis
    @require_google_apis = true
  end

  def icon_tooltip(type)
    case type
      when :public
        raw "<a class=\"public\" href=\"#\" rel=\"tooltip\" title=\"#{t("users.public_field")}\"></a>"
      when :private
        raw "<a class=\"private\" href=\"#\" rel=\"tooltip\" title=\"#{t("users.private_field")}\"></a>"
      when :fully_private
        raw "<a class=\"fully_private\" href=\"#\" rel=\"tooltip\" title=\"#{t("users.fully_private_field")}\"></a>"
    end
  end

  def support_email
    SiteConfig.support_email
  end

  def site_name
    SiteConfig.site_name
  end

  def site_tagline
    SiteConfig.site_tagline
  end
  
  def gallery(name)
    g = Gallery.find_by_name(name)
    if !g.nil?
      @g_items = g.gallery_items.active
      render :partial => "galleries/list", :locals => { :g_items => @g_items }
    end
  end
end
