class SessionsController < ApplicationController
  def new
    redirect_current_user_home
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:info] = 'You are signed in, enjoy!'
      redirect_to home_path
    else
      flash[:danger] = 'Invalid email or password.'
      redirect_to signin_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'You are signed out.'
    redirect_to signin_path
  end
end