require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get account_add_url
    assert_response :success
  end

end
