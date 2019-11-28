class ProjectsController < ApplicationController

	before_action :separate_logs
	after_action :separate_logs

	def show
		@course = Course.find_by_slug(params[:course_slug])
		@project = @course.projects.find_by_slug(params[:slug])
	end

end
