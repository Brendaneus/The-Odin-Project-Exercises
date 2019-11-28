require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@course_one = courses(:one)
		@course_two = courses(:two)

		@course_one_project_one = projects(:one_one)
		@course_one_project_two = projects(:one_two)
		@course_two_project_one = projects(:two_one)
		@course_two_project_two = projects(:two_two)
	end

	test "should get index" do
		get courses_path
		# assert_response :success

		assert_select 'a[href=?]', course_path(@course_one.slug), 1
		assert_select 'a[href=?]', course_path(@course_two.slug), 1
	end

	test "should get show" do
		get course_path(@course_one.slug)
		assert_response :success

		assert_select 'a[href=?]', @course_one.tutorial, 1

		assert_select 'a[href=?]', course_project_path(@course_one.slug, @course_one_project_one.slug), 1
		assert_select 'a[href=?]', course_project_path(@course_one.slug, @course_one_project_two.slug), 1

		assert_select 'a[href=?]', course_project_path(@course_two.slug, @course_one_project_one.slug), 0
		assert_select 'a[href=?]', course_project_path(@course_two.slug, @course_one_project_two.slug), 0
	end

end
