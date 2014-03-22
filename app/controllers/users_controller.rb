class UsersController < ApplicationController
  include StripeWrapper

  before_action :require_user, only: [:show]
  before_action :redirect_current_user_home, except: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(invitation: invitation, email: invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    render :new and return unless @user.valid?
    charge = StripeWrapper::Charge.create(
      amount: 999,
      card: params[:stripeToken],
      description: "Sign up charge for #{@user.email}"
    )
    if charge.successful?
      handle_create_user
      handle_invitation
      redirect_to signin_path
    else
      flash[:danger] = charge.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name, :invitation_id)
  end

  def handle_create_user
    @user.save
    flash[:info] = 'Thank you for joining MyFLiX! Please sign in.'
    UserMailer.delay.welcome_email(@user)
  end

  def handle_invitation
    if params[:user][:invitation_id].present?
      invitation = Invitation.find(@user.invitation_id)
      @user.follow(invitation.sender)
      invitation.sender.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end