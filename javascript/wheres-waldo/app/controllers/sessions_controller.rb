class SessionsController < ApplicationController

  def new_login
  end

  def login
    unset_score if score_set?
    if ( @user = User.find_by(name: params[:name]) ) && @user.authenticates?( :password, params[:password] )
      log_in_as @user
      flash[:success] = "Now logged in as #{@user.name}."
      redirect_to root_path
    else
      flash.now[:failure] = "There was a problem logging in."
      render :new_login
    end
  end

  def logout
    if logged_in?
      log_out
      flash[:success] = "You are now signed out."
      redirect_to root_path
    else
      flash[:failure] = "You have no session to log out."
      redirect_to root_path
    end
  end

end
