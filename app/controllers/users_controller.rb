class UsersController < ApplicationController
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
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @user = User.new(user_params)

    begin
      raise Exception.new('Invalid user input') unless @user.save
      Stripe::Charge.create(
        amount: 999,
        currency: 'usd',
        card: params[:stripeToken],
        description: "Sign up charge for #{@user.email}"
      )
      handle_invitation
      flash[:info] = 'Thank you for joining MyFLiX! Please sign in.'
      UserMailer.delay.welcome_email(@user)
      redirect_to signin_path
    rescue Exception => e
      flash.now[:danger] = e.message
      render :new
    rescue Stripe::CardError => e
      flash.now[:danger] = e.message
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

  def handle_invitation
    if params[:user][:invitation_id].present?
      invitation = Invitation.find(@user.invitation_id)
      @user.follow(invitation.sender)
      invitation.sender.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end