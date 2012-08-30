require 'test_helper'

class AbstractsControllerTest < ActionController::TestCase
  setup do
    @abstract = abstracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abstracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abstract" do
    assert_difference('Abstract.count') do
      post :create, abstract: { body: @abstract.body, user_id: @abstract.user_id }
    end

    assert_redirected_to abstract_path(assigns(:abstract))
  end

  test "should show abstract" do
    get :show, id: @abstract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @abstract
    assert_response :success
  end

  test "should update abstract" do
    put :update, id: @abstract, abstract: { body: @abstract.body, user_id: @abstract.user_id }
    assert_redirected_to abstract_path(assigns(:abstract))
  end

  test "should destroy abstract" do
    assert_difference('Abstract.count', -1) do
      delete :destroy, id: @abstract
    end

    assert_redirected_to abstracts_path
  end
end
