require 'test_helper'

class ProblemsControllersTest	< ActionDispatch::IntegrationTest
		#detroy action tests
		
		def setup
			@user=users(:go6o)
			@problem=problems(:problem1_by_user2)
			@custom_problem=@user.uploaded_problems.create!(content: "neko + sa6o", 
																											title: "love", 
																											answer: 42, 
																											degree_of_answer: 10, 
																											units_of_answer: "nenkos", 
																											category: "Electromagnetism",
																											difficulty: 10,
																											length: 60)
			
			@params={ content: "neko + sa6o", 
							title: "love", 
							answer: 42, 
							degree_of_answer: 10, 
							units_of_answer: "nenkos", 
							category: "Electromagnetism",
							difficulty: 10,
							length: 60}
		end
		
	test "should redirect destroy when not signed in" do
    assert_no_difference 'Problem.count' do
      delete problem_path(problems(:problem1_by_user2).id)
    end
    assert_redirected_to new_user_session_path
  end
	
	 test "should redirect destroy for wrong problem" do
    sign_in_as(@user)
    assert_no_difference 'Problem.count' do
      delete problem_path(problems(:problem1_by_user2).id)
    end
    assert_redirected_to root_path
  end

	test "should destroy an allowed problem" do
    sign_in_as(@user)
    assert_difference 'Problem.count', -1 do
      delete problem_path(problems(:problem1_by_user1).id)
    end
    assert_redirected_to root_path
  end

		#CREATE action tests	
	test "should redirect create when not logged in" do
    assert_no_difference 'Problem.count' do
      post problems_path, problem: @params
    end
    assert_redirected_to new_user_session_path
  end
  
  test "should create problem when logged in" do
    sign_in_as(@user)
    assert_difference 'Problem.count', 1 do
      post problems_path, problem: @params
    end
    assert_redirected_to problem_path(Problem.find(Problem.count))
  end

		#update action tests
	test "should not be allowed to update problem when not logged in" do
		title=@problem.title
		patch problem_path(@problem), problem: @params
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
    assert title==@problem.title
  end

	test "should not be allowed to update problem unless creator or admin" do
		sign_in_as(@user)
		title=@problem.title
		patch problem_path(@problem), problem: @params
    assert_redirected_to root_path
    assert_not flash.empty?
    assert title==@problem.title
  end

	test "creator should update problem" do
		sign_in_as(@user)
		patch problem_path(@custom_problem),id: @custom_problem, problem: {title: "newTitle" }		
		@custom_problem=Problem.find(Problem.count)
    assert_redirected_to problem_path(@custom_problem)
    assert_not flash.empty?
    assert_not "love"==@custom_problem.title
    assert @custom_problem.title=="newTitle"
  end

end
