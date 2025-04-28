require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Test Category", description: "Test description")

    @product = Product.create!(
      name: "Test Product",
      description: "Test product description",
      category: @category,
      sku: "TEST-001",
      stock_quantity: 10
    )
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get show" do
    get product_url(@product)
    assert_response :success
  end
end
