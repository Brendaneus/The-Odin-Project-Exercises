module SessionsHelper

  def log_in_as user
    session[:user_id] = user.id
    current_user = user
  end

  def log_out
    session.delete(:user_id)
    session.delete(:score_id)
  end

  def current_user
    if ( user_id = session[:user_id] )
      begin
        @current_user ||= User.find(user_id)
      rescue
        flash.now[:error] = "There was a problem with your login session."
        session.delete(:user_id)
        return nil
      end
    else
      nil
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_as? user
    current_user == user
  end

  def admin_user?
    logged_in? && current_user.admin?
  end

end
