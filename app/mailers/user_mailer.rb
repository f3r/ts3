class UserMailer < BaseMailer
  # ==Description
  # Email sent when the user receives a question
  def new_question(user, question)
    @user      = user
    @question  = question
    @place     = question.place
    @from      = @question.user
    recipients = "#{user.full_name} <#{user.email}>"
    subject    = t('new_question_subject', :sender => @from.anonymized_name)

    mail(:to => recipients, :subject => subject)
  end

  def new_question_reply(user, question)
    @user      = user
    @question  = question
    @place     = question.place
    recipients = "#{user.full_name} <#{user.email}>"
    subject    = t('new_question_reply_subject')

    mail(:to => recipients, :subject => subject)
  end

  # ==Description
  # Email sent when the user receives a message
  def new_message_reply(user, message)
    @user      = user
    @message   = message
    from       = @message.from
    recipients = "#{user.full_name} <#{user.email}>"
    subject    = t('messages.new_reply_subject', :sender => from.anonymized_name)

    mail(:to => recipients, :subject => subject)
  end
end