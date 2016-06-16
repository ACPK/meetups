require 'test_helper'

class MeetupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meetup = meetups(:one)
  end

  test "should get index" do
    get meetups_url
    assert_response :success
  end

  test "should get new" do
    get new_meetup_url
    assert_response :success
  end

  test "should create meetup" do
    assert_difference('Meetup.count') do
      post meetups_url, params: { meetup: { topic: @meetup.topic } }
    end

    assert_redirected_to meetup_path(Meetup.last)
  end

  test "should show meetup" do
    get meetup_url(@meetup)
    assert_response :success
  end

  test "should get edit" do
    get edit_meetup_url(@meetup)
    assert_response :success
  end

  test "should update meetup" do
    patch meetup_url(@meetup), params: { meetup: { topic: @meetup.topic } }
    assert_redirected_to meetup_path(@meetup)
  end

  test "should destroy meetup" do
    assert_difference('Meetup.count', -1) do
      delete meetup_url(@meetup)
    end

    assert_redirected_to meetups_path
  end
end
