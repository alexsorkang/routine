require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase
  test "should get publicroutines" do
    get :publicroutines
    assert_response :success
  end

  test "should get myroutines" do
    get :myroutines
    assert_response :success
  end

  test "should get currentroutine" do
    get :currentroutine
    assert_response :success
  end

  test "should get newroutine" do
    get :newroutine
    assert_response :success
  end

end
