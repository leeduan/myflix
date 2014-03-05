class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    params[:invitation].merge!(sender_id: current_user.id)
    invitation = Invitation.new(invitation_params)

    if invitation.save
      UserMailer.invite_friend(invitation).deliver
      flash[:info] = "You have successfully invited #{invitation.recipient_name}."
      redirect_to invite_path
    else
      flash[:danger] = "You have already invited #{invitation.recipient_name} to join MyFliX."
      @invitation = Invitation.new
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :sender_id)
  end
end