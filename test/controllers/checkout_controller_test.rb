require "test_helper"

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get address" do
    get checkout_address_url
    assert_response :success
  end

  test "should get payment" do
    get checkout_payment_url
    assert_response :success
  end

  test "should get confirm" do
    get checkout_confirm_url
    assert_response :success
  end

  test "should get complete" do
    get checkout_complete_url
    assert_response :success
  end
end
