require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@course_one = Course.create!(name: "Course One")
		@course_one_project_one = @course_one.projects.create!(name: "Project One")
		@course_one_project_two = @course_one.projects.create!(name: "Project Two")
		@course_two = Course.create!(name: "Course Two")
		@course_two_project_one = @course_two.projects.create!(name: "Another Project One")
		@course_two_project_two = @course_two.projects.create!(name: "Another Project Two")
	end

	test "should get index" do
		get courses_path
		assert_response :success

		assert_select 'a[href=?]', course_path(@course_one), 1
		assert_select 'a[href=?]', course_path(@course_two), 1
	end

	test "should get show" do
		get course_path(@course_one)
		assert_response :success

		assert_select 'a[href=?]', course_project_path(@course_one, @course_one_project_one), 1
		assert_select 'a[href=?]', course_project_path(@course_one, @course_one_project_two), 1

		assert_select 'a[href=?]', course_project_path(@course_two, @course_one_project_one), 0
		assert_select 'a[href=?]', course_project_path(@course_two, @course_one_project_two), 0
	end

end
