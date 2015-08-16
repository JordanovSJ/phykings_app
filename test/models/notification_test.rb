require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  
  def setup
		@user = users(:go6o)
		@notification = @user.notifications.build(message: "message")
  end
  
  test "notification should be valid" do
		assert @notification.valid?
  end
  
  test "notification should have user_id present" do
		@notification.user_id = nil
		assert_not @notification.valid?
  end
  
  test "notification should have message present" do
		@notification.message = " "
		assert_not @notification.valid?
  end
  
end
