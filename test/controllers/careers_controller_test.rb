require 'test_helper'

class CareersControllerTest < ActionController::TestCase
  setup do
    @career = careers(:js)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:careers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create career" do
    assert_difference('Career.count') do
      post :create, career: { name: 'dev-ops',
                              description: 'Like a sysadmin that write code',
                              requirements: fixture_file_upload('files/dev-ops.csv') }
    end

    requirements = Career.find_by(name: 'dev_ops').requirements
    refute requirements.empty?
    assert_redirected_to career_path(assigns(:career))
  end

  test "should show career" do
    get :show, id: @career
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @career
    assert_response :success
  end

  test "should update career" do
    patch :update, id: @career, career: { description: @career.description, name: @career.name }
    assert_redirected_to career_path(assigns(:career))
  end

  test "should destroy career" do
    assert_difference('Career.count', -1) do
      delete :destroy, id: @career
    end

    assert_redirected_to careers_path
  end
end
