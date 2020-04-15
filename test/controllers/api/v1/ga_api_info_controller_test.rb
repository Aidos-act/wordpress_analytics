require 'test_helper'

class Api::V1::GaApiInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_ga_api_info_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_ga_api_info_show_url
    assert_response :success
  end

end
