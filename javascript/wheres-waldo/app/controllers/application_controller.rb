class ApplicationController < ActionController::Base

  include ApplicationHelper

  add_flash_types :success, :failure, :warning

  def require_login
    unless logged_in?
      flash[:warning] = "You must be logged in to do that."
      redirect_to login_path
    end
  end

  def require_admin
    unless admin_user?
      flash[:warning] = "You must be an admin to do that."
      redirect_back fallback_location: root_path
    end
  end

end
