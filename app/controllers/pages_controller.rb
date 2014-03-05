class PagesController < ApplicationController
  def front
    redirect_current_user_home
  end

  def expired; end
end