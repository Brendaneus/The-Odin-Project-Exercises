class ApplicationController < ActionController::Base
	def sign_in user
		user.remember
		cookies.permanent.signed[:remember_token] = user.remember_token
		current_user = user
	end

	def sign_out user
		user.forget
		cookies.delete(:remember_token)
		current_user = nil
	end

	def current_user
		if token = decode_cookie( :remember_token )
			@user ||= User.find_by remember_digest: User.digest( token )
		end
	end

	def current_user=(user)
		@current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	# Add error handling for nil / invalid cookies
	def decode_cookie key
		if ( cookie = cookies[key] )
			Base64.decode64( cookies[key].split('--').first ).chomp('"').reverse.chomp('"').reverse # Is there a better way to do this?
		end
	end
end
