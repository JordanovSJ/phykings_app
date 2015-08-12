require 'test_helper'

class LayoutViewTest < ActionDispatch::IntegrationTest
include Capybara::DSL
  
  def setup
		@user = users(:ivan)
  end
  
  test "front page capybara test" do
		visit("/")
		assert page.has_link?("Facebook", {href: user_omniauth_authorize_path(:facebook)})
		assert page.has_link?("Google", {href: user_omniauth_authorize_path(:google_oauth2)})
		assert page.has_link?("Email", {href: new_user_registration_url})
		assert page.has_link?("Log in", {href: new_user_session_url})
		assert page.has_link?("Sign up", {href: new_user_registration_url})
		assert page.has_link?("Our Mission")
		assert page.has_link?("Rules")
		assert page.has_link?("About us")
		assert page.has_link?("Contact")
  end
  
  test "should log in with ivan" do
		visit("/")
		click_on("Log in")
		assert page.has_field?("Email", type: "email")
		assert page.has_field?("Password", type: "password")
		assert page.has_link?("Log in", count: 1)
		assert page.has_button?("Log in", count: 1)
		fill_in("Email", with: @user.email)
		fill_in("Password", with: "foobar00")
		click_button("Log in")
		assert page.has_link?("Home")
		assert page.has_link?("Competitions")
		assert page.has_link?("Problems and solutions")
		assert page.has_link?("Help")
		assert page.assert_text(@user.email)
		
		# When you click home you should get the Profile sidebar
		within(".container-fluid .navbar-collapse") do
			click_on("Home")
		end
		
		within("#sidebar") do
			assert page.assert_text("Profile")
		end
		
		# When you click Profile->Personal Info you should get the Profile sidebar
		within(".container-fluid .navbar-collapse") do
			click_on("Personal info")
		end
		
		within("#sidebar") do
			assert page.assert_text("Profile")
		end
		
		# When you click Competitions->Active Competitions you should get the Competitions sidebar
		within(".container-fluid .navbar-collapse") do
			click_on("Active competitions")
		end
		
		within("#sidebar") do
			assert page.assert_text("Competitions")
		end
		
		# When you click P&S->Upload Problem you should get the P&S sidebar
		within(".container-fluid .navbar-collapse") do
			click_on("Upload Problem")
		end
		
		within("#sidebar") do
			assert page.assert_text("Problems & Solutions")
		end
		
		# When you click Help->Rules you should get the Help sidebar
		within(".container-fluid .navbar-collapse") do
			click_on("Rules")
		end
		
		within("#sidebar") do
			assert page.assert_text("Help")
		end
		
  end
  
end
