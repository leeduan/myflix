class UserMailer < ActionMailer::Base
  default from: 'noreply@leeduan.com'

  def welcome_email(user)
    @user = user
    @url = "http://ld-myflix.herokuapp.com#{signin_path}"
    mail to: @user.email, subject: 'Welcome to MyFLiX'
  end
end