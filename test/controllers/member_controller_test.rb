require 'test_helper'

class MemberControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get member_edit_url
    assert_response :success
  end

end
