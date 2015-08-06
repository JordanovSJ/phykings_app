require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
		@valid_user = User.new(email: "hara@lampi.com", first_name: "Haralampi", 
													 last_name: "Popov", age: 18,
													 country: "Bulgaria", password: "foobar00",
													 password_confirmation: "foobar00")
  end
  
  test "valid_user should be valid" do
		assert @valid_user.valid?
  end
  
  test "email should be present" do
		@valid_user.email = " "
		assert_not @valid_user.valid?
  end
  
  test "first name should be present" do
		@valid_user.first_name = " "
		assert_not @valid_user.valid?
  end
  
  test "last name should be present" do
		@valid_user.last_name = " "
		assert_not @valid_user.valid?
  end
  
  test "age should be between 1 and 100" do
		@valid_user.age = 101
		assert_not @valid_user.valid?
		@valid_user.age = 0
		assert_not @valid_user.valid?
  end
  
  test "country should be present" do
		@valid_user.country = " "
		assert_not @valid_user.valid?
  end
  
end
