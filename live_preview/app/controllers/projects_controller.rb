class ProjectsController < ApplicationController

	def show
		@course = Course.find(params[:course_id])
		@project = @course.projects.find(params[:id])
	end

end
