ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require "test_helper"
require "capybara/rails"
Minitest::Reporters.use!
# Make the Capybara DSL available in all integration tests

class ActiveSupport::TestCase
	include Capybara::DSL
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
    # Logs in a test user.
  def sign_in_as(user)
		post_via_redirect user_session_path, 
		'user[email]' => user.email, 'user[password]' => "password" 
  end
 
end
