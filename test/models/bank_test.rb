require 'test_helper'

class BankTest < ActiveSupport::TestCase

	def setup	
		@user1=users(:go6o) # creator of the problem
		@user2=users(:pe6o) #solver of the problem
		@user3=users(:stamat) #has not relation to the problem
		@problem=problems(:problem1_by_user1)
		@relation=get_custom_relation(@user2,@problem)
		@solution=get_custom_solution(@relation)
		@problem_params=get_params_for_problem
		@solution_params=get_params_for_solution
		@bank=Bank.access
		@bank.total_gold += 1000
		@bank.save!
		@user2.gold += 500
		@user2.save!
	end
	

	test "bank.access is valid" do
		Bank.access.valid?
	end
	 
	#test fail of unlock solutions
	
	test "should not unlock answers when not enough gold" do
		@relationCreator=get_custom_relation(@user1,@problem)
		@solutionCreator=get_custom_solution(@relationCreator) 
		@user2.gold = 100
		@user2.save!
		assert_not @user2.relation_of(@problem).can_see_solution
		assert_not @user2.relation_of(@problem).can_see_answer
		assert Bank.access.present_gold==0
		@user2.unlock_solutions_of(@problem)
		@user2.reload
		assert_not @user2.relation_of(@problem).can_see_solution
		assert_not @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==100 , "#{@user2.gold}"
		assert Bank.access.present_gold== 0, "#{Bank.access.present_gold}"
		assert @user1.gold=0
	end
	
	test "should not unlock answers when can_see_solution already true" do
		@relationCreator=get_custom_relation(@user1,@problem)
		@solutionCreator=get_custom_solution(@relationCreator) 
		@user2.relation_of(@problem).update_attributes!(can_see_solution: true)
		assert Bank.access.present_gold==0
		@user2.unlock_solutions_of(@problem)
		@user2.reload
		assert @user2.gold==500 , "#{@user2.gold}"
		assert Bank.access.present_gold== 0, "#{Bank.access.present_gold}"
		assert @user1.gold=0
	end
	
	
		
	test "unlock solutions of problem" do
		@relationCreator=get_custom_relation(@user1,@problem)
		@solutionCreator=get_custom_solution(@relationCreator) 
		assert_not @user2.relation_of(@problem).can_see_solution
		assert_not @user2.relation_of(@problem).can_see_answer
		assert Bank.access.present_gold==0
		@user2.unlock_solutions_of(@problem)
		@user2.reload
		assert @user2.relation_of(@problem).can_see_solution
		assert @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==180 , "#{@user2.gold}"
		assert Bank.access.present_gold== 50, "#{Bank.access.present_gold}"
		assert @user1.gold=270
	end
	
	test "unlock solutions of problem when already answer unlocked" do
		@relationCreator=get_custom_relation(@user1,@problem)
		@solutionCreator=get_custom_solution(@relationCreator) 
		assert_not @user2.relation_of(@problem).can_see_solution
		@user2.relation_of(@problem).update_attributes!(can_see_answer: true)
		assert Bank.access.present_gold==0
		@user2.unlock_solutions_of(@problem)
		@user2.reload
		assert @user2.relation_of(@problem).can_see_solution
		assert @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==225 , "#{@user2.gold}"
		assert Bank.access.present_gold== 50, "#{Bank.access.present_gold}"
		assert @user1.gold=225
	end
	
	#~ test "unlock solutions of problem when one of the solutions has no user" do
		#~ @relationCreator=get_custom_relation(@user1,@problem)
		#~ @solutionCreator=get_custom_solution(@relationCreator) 
		#~ @user1.destroy
		#~ assert_not @user2.relation_of(@problem).can_see_solution
		#~ @user2.unlock_solutions_of(@problem)
		#~ @user2.reload
		#~ assert @user2.relation_of(@problem).can_see_solution
		#~ assert @user2.gold==225 
		#~ assert Bank.access.present_gold== 275
	#~ end
	
	
	test "unlock answer oof problem" do
		assert_not @user2.relation_of(@problem).can_see_answer
		@user2.unlock_answer_of(@problem)
		@user2.reload
		assert @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==400
		@user1.reload
		assert @user1.gold==90 , "#{@user1.gold}"
		assert Bank.access.present_gold== 10
	end
	
	test "cannot unlock answer of solution because not enough gold" do
		@user2.gold=0
		@user2.save!
		@user2.reload
		assert_not @user2.relation_of(@problem).can_see_answer
		@user2.unlock_answer_of(@problem)
		@user2.reload
		assert_not @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==0
		@user1.reload
		assert @user1.gold==0 , "#{@user1.gold}"
		assert Bank.access.present_gold== 0
	end
	
	test "cannot unlock answer of solution if there is no relation to problem" do
		@user3.gold += 500
		@user3.save!
		@user3.unlock_answer_of(@problem)
		@user3.reload
		assert @user3.gold==500
		assert Bank.access.present_gold== 0
	end
	
	#~ test "unlock answer of problem when problem has no creator" do
		#~ @user1.destroy
		#~ bank=Bank.access
		#~ assert_not @user2.relation_of(@problem).can_see_answer
		#~ @user2.unlock_answer_of(@problem)
		#~ @user2.reload
		#~ assert @user2.relation_of(@problem).can_see_answer
		#~ assert @user2.gold==400
		#~ assert Bank.access.present_gold== 100
	#~ end
	
	
end
