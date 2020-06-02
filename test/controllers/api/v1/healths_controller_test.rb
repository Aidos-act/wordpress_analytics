require 'test_helper'

class Api::V1::HealthsControllerTest < ActionDispatch::IntegrationTest
  test "should get health" do
    get api_v1_healths_health_url
    assert_response :success
  end

end
