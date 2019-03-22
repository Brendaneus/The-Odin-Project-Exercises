class SessionsController < ApplicationController
	def new
	end

	def create
		session_name = params[:session][:name]
		if @user = User.find_by_name( session_name )
			session[:user_id] = @user.id
			flash[:success] = "You have successfully logged into this account."
			redirect_to user_path( @user )
		else
			flash.now[:failure] = "Please enter an existing account name to login."
			render :new
		end
	end

	def destroy
		session.delete( :user_id )
		flash[:success] = "You have successfully logged out of this account."
		redirect_to signin_path
	end
end
