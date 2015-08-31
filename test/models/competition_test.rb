require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
	def setup
		#~ @user=users(:go6o)
		@competition=Competition.new(length: 60, n_players: 3, entry_gold: 10, target: 4)
		#~ @problem=get_custom_problem(@user)
		#~ @competition.competition_problems.create!(problem_id: @problem.id)
		#~ @competition.save!
	end
	
	test "competition valid" do
		assert @competition.valid?
	end
	
	test "length must be present" do
		@competition.length=nil
		assert_not @competition.valid?
	end
	
	test "ln_players must be present" do
		@competition.n_players=nil
		assert_not @competition.valid?
	end
	
	test "entry_gold must be present" do
		@competition.entry_gold=nil
		assert_not @competition.valid?
	end
	
	test "length allowed value" do
		@competition.length=13
		assert_not @competition.valid?	
		@competition.length=-1
		assert_not @competition.valid?		
	end
	
	test "n_players allowed value" do
		@competition.length=21
		assert_not @competition.valid?	
		@competition.length=0
		assert_not @competition.valid?		
	end
	
	test "entry_gold allowed value" do	
		@competition.length=-1
		assert_not @competition.valid?		
	end
end
