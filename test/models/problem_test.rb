require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
	def setup
		@problem=problems(:problem1_by_user1)
	end
	
	test "problem must be valid" do
		assert @problem.valid?
	end
	
	test "title should not be empty" do
		@problem.title=" "
		assert_not @problem.valid?
	end
	
	test "content should not be empty" do
		@problem.content="     "
		assert_not @problem.valid?
	end
	
	test "title should not be longer than 100 characters" do
		@problem.title= "a"*101
		assert_not @problem.valid?
	end

	test "content should not be longer than 3000 characters" do
		@problem.content= "a"*3001
		assert_not @problem.valid?
	end

  test "order should be most recent first" do
    assert_equal problems(:problem2_by_user1), Problem.first
  end

end
