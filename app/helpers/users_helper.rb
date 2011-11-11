module UsersHelper
  def full_name(user)
    name = [user['first_name'], user['last_name']].join(' ')
    name.titleize unless name.eql?(' ')
  end
  
  def short_full_name(user)
    name = [user['first_name'][0], user['last_name']].join('. ')
    name.titleize unless name.eql?(' ')    
  end

  def nickname(user)
    nick = 'no username yet'
    nick = "#{user['first_name'][0]}#{user['last_name']}" unless user['first_name'].nil? && user['last_name'].nil?
  end

  def date_convert(date)
    new_date = date.to_date.strftime("%d %B %Y")
    new_date unless date.blank?
  end

  def profile_picture_url(uid, type)
    if type == "facebook"
      avatar = "https://graph.facebook.com/#{uid}/picture"
    elsif type == "twitter"
      user = RestClient.get("https://api.twitter.com/1/users/show.json?user_id=#{uid}")
      user_info = JSON.parse(user)
      avatar = user_info['profile_image_url']
    end
    avatar
  end
end
