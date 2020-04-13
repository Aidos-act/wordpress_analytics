require 'test_helper'

class Api::V1::ScrollDurationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_scroll_durations_index_url
    assert_response :success
  end

end
