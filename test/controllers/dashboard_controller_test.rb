require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_index_url
    assert_response :success
  end

  test "should get orders" do
    get dashboard_orders_url
    assert_response :success
  end

  test "should get order" do
    get dashboard_order_url
    assert_response :success
  end
end
