module UsersHelper
  def full_name(user)
    name = [user['first_name'], user['last_name']].join(' ')
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

  def profile_picture_url(uid)
    picture_url = "https://graph.facebook.com/#{uid}/picture"
    picture_url unless uid.nil?
  end
end
