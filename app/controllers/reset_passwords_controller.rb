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
    if user
      user.update_attributes(password: params[:password], password_token: nil)
      user.save
      flash[:info] = 'Your password has been changed. Please sign in.'
      redirect_to signin_path
    else
      redirect_to expired_token_path
    end
  end
end