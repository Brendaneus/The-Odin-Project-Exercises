module FlightsHelper
	def search_params_present?
		params[:origin].present? || params[:destination].present? || params[:passengers].present? || params[:departure].present?
	end

	# Relying on instance variables from the controller doesn't feel safe here...
	def search_title_builder
		if search_params_present?
			title = "Searching Flights"
			title += " Departing #{ @airport_options[params[:origin].to_i - 1][0] }" if params[:origin].present?
			if params[:destination].present?
				if params[:origin].present?
					title += " for "
				else
					title += " to "
				end
				title += "#{ @airport_options[params[:destination].to_i - 1][0] }"
			end
			title += " on #{ params[:departure] }" if params[:departure].present?
			title += " for #{ params[:passengers] }" if params[:passengers].present?
			return title
		else
			title = "Search Flights"
		end
	end
end
