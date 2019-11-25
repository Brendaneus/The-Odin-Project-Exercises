class ApplicationController < ActionController::Base

	def separate_logs
		puts "=" * 50 unless Rails.env.test?
	end

end
