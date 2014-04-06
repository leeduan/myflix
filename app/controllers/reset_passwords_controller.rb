class ResetPasswordsController < ApplicationController
  before_action :redirect_current_user_home

  def show
    user = User.find_by(password_token: params[:id])
    if user
      @token = user.password_token
    else
      redirect_to expired_token_path
    end
  end

  def expired; end

  def update
    user = User.find_by(password_token: params[:id])
    redirect_to expired_token_path and return unless user
    user.update_attributes(
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      password_token: nil
    )
    if user.save
      flash[:info] = 'Your password has been changed. Please sign in.'
      redirect_to signin_path
    else
      flash[:danger] = 'Passwords do not match. Please try again.'
      @token = user.password_token
      render :show
    end
  end
end
