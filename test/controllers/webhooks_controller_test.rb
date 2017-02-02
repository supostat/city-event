require 'test_helper'

class WebhooksControllerTest < ActionController::TestCase
  test "should get createCityUser" do
    get :createCityUser
    assert_response :success
  end

end
