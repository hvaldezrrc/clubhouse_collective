require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    StaticPage.create!(
      title: "About Us",
      slug: "about",
      content: "This is About Us page content."
    )

    assert StaticPage.find_by(slug: "about").present?

    get "/about"
    assert_response :success
  end
end
