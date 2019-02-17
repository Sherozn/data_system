require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get account_login_url
    assert_response :success
  end

  test "should get signup" do
    get account_signup_url
    assert_response :success
  end

end
