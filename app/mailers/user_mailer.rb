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

  def invite_friend(invitation)
    @invitation = invitation
    mail to: @invitation.recipient_email, subject: 'Invite to join MyFLiX'
  end

  def suspended_account(user)
    @user = user
    mail to: @user.email, subject: 'MyFLiX Account Deactivated'
  end
end
