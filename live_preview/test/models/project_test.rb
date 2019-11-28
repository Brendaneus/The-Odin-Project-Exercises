require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

	def setup
		@course = courses(:one)
		@project = projects(:one_one)
	end

	test "sample data is valid" do
		@project.valid?
	end

	test "belongs_to course" do
		@project.course == @course
	end

	test "name must be present" do
		@project.name = ""
		assert_not @project.valid?
		@project.name = "   "
		assert_not @project.valid?
	end

	test "name must be unique" do
		@copy_project = @course.projects.create(name: @project.name)
		assert_not @copy_project.valid?
	end

	test "name can't be too long (50)" do
		@project.name = "X" * 50
		assert @project.valid?
		@project.name = "X" * 51
		assert_not @project.valid?
	end

	test "complete defaults as true" do
		assert @project.complete? == true
	end

	test "visible defaults as true" do
		assert @project.visible? == true 
	end

	test "should scope visible courses" do
		@invisible_project = @course.projects.create!(name: "Invisible Project", visible: false)
		assert Project.visible.include? @project
		assert_not Project.visible.include? @invisible_project
	end

end
