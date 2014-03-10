class AdminsController < ApplicationController
  before_action :require_admin

  def require_admin
    redirect_to home_path unless (logged_in? && current_user.admin?)
  end
end