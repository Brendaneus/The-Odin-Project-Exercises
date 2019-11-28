class CoursesController < ApplicationController

	before_action :separate_logs
	after_action :separate_logs

	def index
		@courses = Course.visible.includes(:projects)
	end

	def show
		@course = Course.includes(:projects).find_by_slug(params[:slug])
		@projects = @course.projects.visible
	end

end
