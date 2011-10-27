module UsersHelper
  def full_name(user)
    name = [user['first_name'], user['last_name']].join(',')
    name unless name.eql?(',')
  end
end
