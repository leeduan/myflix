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
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      UserMailer.welcome_email(@user).deliver
      flash[:info] = 'Thank you for joining MyFLiX! Please sign in.'
      redirect_to signin_path
    else
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