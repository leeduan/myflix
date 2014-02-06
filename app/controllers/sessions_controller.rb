class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You've logged out."
    redirect_to signin_path
  end
end