class ForgotPasswordsController < ApplicationController
  before_action :redirect_current_user_home

  def new; end

  def create
    user = User.find_by(email: params[:email])
    user.try(:generate_password_token)
    UserMailer.password_reset(user).deliver if user
    redirect_to confirm_password_reset_path
  end

  def confirm; end
end