class UsersController < ApplicationController
  before_action :require_user, only: [:show, :edit, :update]
  before_action :redirect_current_user_home, except: [:show, :edit, :update]

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
    result = UserRegistration.new(@user).register(params[:stripeToken], params[:user][:invitation_id])

    if result.successful?
      flash[:info] = 'Thank you for joining MyFLiX! Please sign in.'
      redirect_to signin_path
    else
      flash[:danger] = result.error_message if result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    flash[:info] = 'Success! Your account has been updated.'
    redirect_to home_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name, :invitation_id)
  end
end
