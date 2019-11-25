class ProjectsController < ApplicationController

	before_action :separate_logs
	after_action :separate_logs

	def show
		@course = Course.find(params[:course_id])
		@project = @course.projects.find(params[:id])
	end

end
