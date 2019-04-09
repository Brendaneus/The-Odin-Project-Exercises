class StaticPagesController < ApplicationController

	def home
		if search_id = params[:search_id]
			begin
				@person = Flickr.people.find(search_id)
				@person.get_info!
				@photos = @person.public_photos(sizes: true).map(&:original!)
			rescue
				@person = nil
				@photos = nil
				flash.now[:error] = "There was an error.  Please check your User ID and try again."
			end
		end
	end

end
