require "test_helper"

class AddressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @address = addresses(:one)
  end

  test "should get edit" do
    get edit_address_url(@address)
    assert_response :success
  end

  test "should get update" do
    patch address_url(@address), params: { address: { street: "New Street", city: "New City", postal_code: "12345" } }

    assert_redirected_to dashboard_url
  end
end
