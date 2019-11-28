require 'test_helper'

class CourseTest < ActiveSupport::TestCase
	
	def setup
		@course = courses(:one)
	end

	test "sample data is valid" do
		assert @course.valid?
	end

	test "has_many projects" do
		@project = @course.projects.create!(name: "Sample Project")
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

	test "visible defaults as true" do
		assert @course.visible? == true
	end

	test "should check if all projects are completed" do
		@course.projects.create!(name: "Complete Project", complete: true)
		assert @course.complete?

		@course.projects.create!(name: "Incomplete Project", complete: false)
		assert_not @course.complete?

		# Return false if course empty
		@new_course = Course.create!(name: "New Project")
		assert @new_course.complete? == false
	end

	test "should scope visible courses" do
		@invisible_course = Course.create!(name: "Invisible Course", visible: false)
		assert Course.visible.include? @course
		assert_not Course.visible.include? @invisible_course
	end

end
