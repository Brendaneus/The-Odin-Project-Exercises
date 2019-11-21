require 'test_helper'

class CourseTest < ActiveSupport::TestCase
	
	def setup
		@course = Course.create(name: "Sample Course")
	end

	test "sample data is valid" do
		assert @course.valid?
	end

	test "has_many projects" do
		@project = @course.projects.create(name: "Sample Project")
		assert @course.projects.include?(@project)
	end

	test "name must be present" do
		@course.name = ""
		assert_not @course.valid?
		@course.name = "   "
		assert_not @course.valid?
	end

	test "name must be unique" do
		@copy_course = Course.create(name: @course.name)
		assert_not @copy_course.valid?
	end

	test "name can't be too long (50)" do
		@course.name = "X" * 50
		assert @course.valid?
		@course.name = "X" * 51
		assert_not @course.valid?
	end

end
