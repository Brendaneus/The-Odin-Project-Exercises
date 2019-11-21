ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"

class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	fixtures :all
	Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

	# Add more helper methods to be used by all tests here...
end
