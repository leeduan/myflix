class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def redirect_current_user_home
    redirect_to home_path and return if logged_in?
  end

  def require_user
    unless logged_in?
      flash[:danger] = 'Access reserved for members only. Please sign in first.'
      redirect_to signin_path
    end
  end
end
