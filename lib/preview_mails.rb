class PreviewMails < MailView

  ###############################################################
  # REGISTRATION_MAILER
  ###############################################################
  def welcome_instructions
    user = User.first
    RegistrationMailer.welcome_instructions(user)
  end

  def reset_password
    user = User.first
    RegistrationMailer.reset_password_instructions(user)
  end

  def new_question
    user = User.first
    question = Comment.first
    UserMailer.new_question(user, question)
  end

  def new_question_reply
    question = Comment.first
    user = question.user
    UserMailer.new_question_reply(user, question)
  end
end