require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get member" do
    get dashboard_member_url
    assert_response :success
  end

  test "should get admin" do
    get dashboard_admin_url
    assert_response :success
  end

  test "should get group" do
    get dashboard_group_url
    assert_response :success
  end

end
