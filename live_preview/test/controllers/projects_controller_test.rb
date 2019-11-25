require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@course = Course.create!(name: "Sample Course")
		@project = @course.projects.create!(name: "Sample Project", url: "www.example.com")
	end

	test "should get show" do
		get course_project_path(@course, @project)
		assert_response :success

		assert_select 'h1', @project.name
		assert_select 'a[href=?]', @project.url
	end

end
