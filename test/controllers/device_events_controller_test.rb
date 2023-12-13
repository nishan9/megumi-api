require "test_helper"

class DeviceEventsControllerTest < ActionDispatch::IntegrationTest

  class DeviceEventsCreateTest < DeviceEventsControllerTest

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

  class DeviceEventsUpdateNotificationTest < DeviceEventsControllerTest

    test "update notification_sent flag to true when it set to false" do
      device_event = DeviceEvent.create(notification_sent: false)
      patch '/api/v1/device_events/#{device_event.id}/update-notification'
      assert_response :ok
      device_event = JSON.parse(response.body)
      assert_true device_event['notification_sent']
    end


    test "return not found when the supplied event does not exist" do
      non_existent_event_id = 47382
      patch "/api/v1/device_events/#{non_existent_event_id}/update-notification"
      assert_response :not_found
    end

    test "return unprocessable entity and error message if the flag was set to true already" do
      device_event = DeviceEvent.create(notification_sent: true)
      patch "/api/v1/device_events/#{device_event.id}/update-notification"
      assert_response :unprocessable_entity
      error_response = JSON.parse(response.body)
      assert_equal error_response, 'notification_sent was already set to true'
    end

  end
  
end