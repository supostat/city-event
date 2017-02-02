require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get summary" do
    get :summary
    assert_response :success
  end

  test "should get detail" do
    get :detail
    assert_response :success
  end

end
