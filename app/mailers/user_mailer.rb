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
end