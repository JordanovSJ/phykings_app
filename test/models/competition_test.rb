require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
	def setup
		@competition=Competition.new(length: 10, n_players: 3, entry_gold: 10)
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
