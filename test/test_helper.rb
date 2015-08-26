ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require "test_helper"
require "capybara/rails"
Minitest::Reporters.use!

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
 
 
	def get_custom_problem(user)
		user.uploaded_problems.create!(content: "custom_problem_content", 
																											title: "custom_problem_title", 
																											answer: 42, 
																											degree_of_answer: 10, 
																											units_of_answer: "nenkos", 
																											category: "Electromagnetism",
																											difficulty: 10,
																											target: 1,
																											length: 60)
	end
	
	def get_custom_relation(user,problem)
		user.user_problem_relations.create!(seen_problem_id: problem.id)
	end
	
	def get_custom_solution(relation)
		relation.update_attributes(provided_with_solution: true)
		
		Solution.create!(user_problem_relation_id: relation.id, 
										content: "custom_solution_content",
										answer: 42, 
										degree_of_answer: 10)
					
	end
	
	def get_custom_competition
		Competition.create!(n_players: 2,
												entry_gold: 0,
												length: 30)
	end
	
	
	def get_params_for_problem
		params={ content: "params_problem_content", 
							title: "params_problem_title", 
							answer: 42, 
							degree_of_answer: 10, 
							units_of_answer: "nenkos", 
							category: "Electromagnetism",
							difficulty: 10,
							target: 1,
							length: 60}
	end
	
	def get_params_for_solution
		params={ content: "params_solution_content", 
								answer: 42, 
								degree_of_answer: 10}
	end
end

	def get_params_for_competition
		params={n_players: 3,
						entry_gold: 0,
						length: 30}
	end
