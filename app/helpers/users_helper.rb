module UsersHelper
  def full_name(user)
    name = [user['first_name'], user['last_name']].join(' ')
    name unless name.eql?(' ')
  end
  
  def nickname(user)
    nick = 'no username yet'
    nick = "#{user['first_name'][0]}#{user['last_name']}" unless user['first_name'].nil? && user['last_name'].nil?
  end
end
