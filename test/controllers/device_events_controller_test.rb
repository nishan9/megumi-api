require "test_helper"

class DeviceEventsControllerTest < ActionDispatch::IntegrationTest

  test "create valid device event with valid parameters" do
    post '/api/v1/device_events', params: { device_event: { category: 1, recorded_at: Date.current } }
    assert_response :ok
    device_event = JSON.parse(response.body)
    assert_not_nil device_event['uuid']
    assert_equal 1, device_event['category']
  end

  test "create invalid device event with category parameter missing" do
    post '/api/v1/device_events', params: { device_event: { recorded_at: Date.current } }
    assert_response :unprocessable_entity
    errors = JSON.parse(response.body)
    expected_error_message = { "category" => ["can't be blank"] }
    assert_equal expected_error_message, errors
  end

  test "create invalid device event with recorded_at parameter missing" do
    post '/api/v1/device_events', params: { device_event: { category: 1 } }
    assert_response :unprocessable_entity
    errors = JSON.parse(response.body)
    expected_error_message = { "recorded_at" => ["can't be blank"] }
    assert_equal expected_error_message, errors
  end

end