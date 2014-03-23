class UserRegistration
  attr_reader :user, :status, :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invitation_token)
    if user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: stripe_token,
        description: "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        user.save
        UserMailer.delay.welcome_email(user)
        handle_invitation(Invitation.find(invitation_token)) if invitation_token.present?
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = nil
    end
    self
  end

  def successful?
    status == :success
  end

  private

  def handle_invitation(invitation)
    user.follow(invitation.sender)
    invitation.sender.follow(user)
    invitation.update_column(:token, nil)
  end
end