class ApplicationController < ActionController::Base
	include ApplicationHelper

	def require_login
		unless logged_in?
			flash[:warning] = "You must be logged in to do this."
			redirect_to signin_path
		end
	end
end
