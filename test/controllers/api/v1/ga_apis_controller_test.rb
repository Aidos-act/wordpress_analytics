require 'test_helper'

class Api::V1::GaApisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_ga_apis_index_url
    assert_response :success
  end

  test "should get new" do
    get api_v1_ga_apis_new_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_ga_apis_create_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_ga_apis_show_url
    assert_response :success
  end

  test "should get edit" do
    get api_v1_ga_apis_edit_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_ga_apis_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_ga_apis_destroy_url
    assert_response :success
  end

end
