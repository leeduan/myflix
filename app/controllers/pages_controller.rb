class PagesController < ApplicationController
  def front
    redirect_to home_path and return if logged_in?
  end
end