require 'test_helper'

class TeamControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get team_index_url
    assert_response :success
  end

  test "should get show" do
    get team_show_url
    assert_response :success
  end

  test "should get new" do
    get team_new_url
    assert_response :success
  end

end
