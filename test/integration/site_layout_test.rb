require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  #def setup
  #  @user = users(:SA6O.ALEX)
  #end




test "layout links as not-logged-in" do
    
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", '/static_pages/front_page_text?info_partial=about' , count: 1
    assert_select "a[href=?]", '/static_pages/front_page_text?info_partial=contacts' , count: 1
    assert_select "a[href=?]", '/static_pages/front_page_text?info_partial=mission' , count: 1
    assert_select "a[href=?]", '/static_pages/front_page_text?info_partial=rules' , count: 1
    #assert_select "a[href=?]", login_path
    #assert_select "a[href=?]", sign_up
  end

test "layout links as logged-in" do
    #log_in_as(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 1 #2?
    #assert_select "a[href=?]", logout_path
		#dropdown menu links!!!!!
  end
end
