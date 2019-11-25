class CoursesController < ApplicationController

	before_action :separate_logs
	after_action :separate_logs

	def index
		@courses = Course.visible
	end

	def show
		@course = Course.find(params[:id])
		@projects = @course.projects.visible
	end

end
