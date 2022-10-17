require 'test_helper'

class KiyakuControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kiyaku_index_url
    assert_response :success
  end

end
