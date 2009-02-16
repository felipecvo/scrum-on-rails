require 'test_helper'

class ProjectUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_users" do
    assert_difference('ProjectUsers.count') do
      post :create, :project_users => { }
    end

    assert_redirected_to project_users_path(assigns(:project_users))
  end

  test "should show project_users" do
    get :show, :id => project_users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_users(:one).id
    assert_response :success
  end

  test "should update project_users" do
    put :update, :id => project_users(:one).id, :project_users => { }
    assert_redirected_to project_users_path(assigns(:project_users))
  end

  test "should destroy project_users" do
    assert_difference('ProjectUsers.count', -1) do
      delete :destroy, :id => project_users(:one).id
    end

    assert_redirected_to project_users_path
  end
end
