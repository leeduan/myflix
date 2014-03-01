class UserMailer < ActionMailer::Base
  default from: 'noreply@leeduan.com'

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to MyFLiX'
  end

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: 'Reset MyFLiX Password'
  end
end