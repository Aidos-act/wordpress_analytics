require 'test_helper'

class Api::V1::ScrollsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_scrolls_show_url
    assert_response :success
  end

end
