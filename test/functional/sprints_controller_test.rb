require 'test_helper'

class SprintsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sprints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sprint" do
    assert_difference('Sprint.count') do
      post :create, :sprint => { }
    end

    assert_redirected_to sprint_path(assigns(:sprint))
  end

  test "should show sprint" do
    get :show, :id => sprints(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sprints(:one).id
    assert_response :success
  end

  test "should update sprint" do
    put :update, :id => sprints(:one).id, :sprint => { }
    assert_redirected_to sprint_path(assigns(:sprint))
  end

  test "should destroy sprint" do
    assert_difference('Sprint.count', -1) do
      delete :destroy, :id => sprints(:one).id
    end

    assert_redirected_to sprints_path
  end
end
