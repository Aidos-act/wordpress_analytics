require 'test_helper'

class Api::V1::ClicksControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_clicks_show_url
    assert_response :success
  end

end
