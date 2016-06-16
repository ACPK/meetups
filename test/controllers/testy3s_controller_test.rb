require 'test_helper'

class Testy3sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @testy3 = testy3s(:one)
  end

  test "should get index" do
    get testy3s_url
    assert_response :success
  end

  test "should get new" do
    get new_testy3_url
    assert_response :success
  end

  test "should create testy3" do
    assert_difference('Testy3.count') do
      post testy3s_url, params: { testy3: { some2: @testy3.some2, some3: @testy3.some3, some: @testy3.some } }
    end

    assert_redirected_to testy3_path(Testy3.last)
  end

  test "should show testy3" do
    get testy3_url(@testy3)
    assert_response :success
  end

  test "should get edit" do
    get edit_testy3_url(@testy3)
    assert_response :success
  end

  test "should update testy3" do
    patch testy3_url(@testy3), params: { testy3: { some2: @testy3.some2, some3: @testy3.some3, some: @testy3.some } }
    assert_redirected_to testy3_path(@testy3)
  end

  test "should destroy testy3" do
    assert_difference('Testy3.count', -1) do
      delete testy3_url(@testy3)
    end

    assert_redirected_to testy3s_path
  end
end
