class SessionsController < ApplicationController
	def new
		
	end

	def create
		@user = User.find_by( email: params[:session][:email] )
		if ( @user && @user.authenticate( params[:session][:password] ) )
			sign_in @user
			flash[:success] = "Successfully signed in."
			redirect_to posts_path
		else
			flash.now[:error] = (@user) ? "Invalid password for '#{params[:session][:email]}'." : "User '#{params[:session][:email]}' not found."
			render :new
		end
	end

	def destroy
		if ( user = current_user )
			sign_out user
			flash[:alert] = "You are now signed out."
		else
			flash[:alert] = "You are not signed in."
		end
		redirect_to signin_path
	end
end
