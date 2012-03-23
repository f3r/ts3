module MessagesHelper
  def message_from(from)
    first_name = from['first_name']
    last_name = from['last_name']
    "#{first_name[0]}. #{last_name[0]}."
  end
end