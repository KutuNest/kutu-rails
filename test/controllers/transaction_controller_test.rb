require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get transaction_list_url
    assert_response :success
  end

  test "should get show" do
    get transaction_show_url
    assert_response :success
  end

  test "should get update" do
    get transaction_update_url
    assert_response :success
  end

end
