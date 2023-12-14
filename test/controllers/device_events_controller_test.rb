require "test_helper"

class DeviceEventsControllerTest < ActionDispatch::IntegrationTest

  class DeviceEventsCreateTest < DeviceEventsControllerTest

    test "create valid device event with valid parameters" do
      post '/api/v1/device_events', params: { device_event: { category: 2, recorded_at: Date.current } }
      assert_response :ok
      device_event = JSON.parse(response.body)
      assert_not_nil device_event['uuid']
      assert_equal 2, device_event['category']
    end
  
    test "create invalid device event with category parameter missing" do
      post '/api/v1/device_events', params: { device_event: { recorded_at: Date.current } }
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { "category" => ["can't be blank"] }
      assert_equal expected_error_message, error_message
    end
  
    test "create invalid device event with recorded_at parameter missing" do
      post '/api/v1/device_events', params: { device_event: { category: 1 } }
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { "recorded_at" => ["can't be blank"] }
      assert_equal expected_error_message, error_message
    end

  end

  class DeviceEventsUpdateNotificationTest < DeviceEventsControllerTest

    test "update notification_sent flag to true when it set to false" do
      device_event = DeviceEvent.create(category:1, recorded_at: Date.today)
      patch "/api/v1/device_events/#{device_event.uuid}/update-notification"
      assert_response :ok
      updated_device_event = JSON.parse(response.body)
      assert_equal updated_device_event['notification_sent'], true
    end

    test "return not found when the supplied event does not exist" do
      non_existent_event_uuid = 47382
      patch "/api/v1/device_events/#{non_existent_event_uuid}/update-notification"
      assert_response :not_found
    end

    test "update notification_sent flag to true when it set to false 2" do
      device_event = DeviceEvent.create(category:3, recorded_at: Date.yesterday)
      patch "/api/v1/device_events/#{device_event.uuid}/update-notification"
      assert_response :ok
      patch "/api/v1/device_events/#{device_event.uuid}/update-notification"
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { "error" => "Notification has already been sent for this event" }
      assert_equal expected_error_message, error_message
    end

  end

  class DeviceEventsGetTest < DeviceEventsControllerTest

    test "get device event" do
      device_event = DeviceEvent.create(category:4, recorded_at: Date.yesterday)
      get "/api/v1/device_events/#{device_event.uuid}"
      assert_response :ok
      assert_equal 4, device_event['category']
      assert_equal device_event.uuid, device_event['uuid']
      assert_equal false, device_event['is_deleted']
      assert_equal false, device_event['notification_sent']
    end

    test "get non existent event" do
      non_existent_event_uuid = 47382
      get "/api/v1/device_events/#{non_existent_event_uuid}"
      assert_response :not_found
    end

  end

  class DeviceEventsGetAllTest < DeviceEventsControllerTest

    test "get all device events" do
      device_event_1 = DeviceEvent.create(category: 6, recorded_at: Date.today)
      device_event_2 = DeviceEvent.create(category: 7, recorded_at: Date.yesterday)
      
      get "/api/v1/device_events"
      assert_response :ok
      all_device_events = JSON.parse(response.body)
      assert_equal 2, all_device_events.length

      assert_equal device_event_1.uuid, all_device_events[0]['uuid']
      assert_equal device_event_1.category, all_device_events[0]['category']
      assert_equal device_event_1.recorded_at.iso8601, all_device_events[0]['recorded_at']

      assert_equal device_event_2.uuid, all_device_events[1]['uuid']
      assert_equal device_event_2.category, all_device_events[1]['category']
      assert_equal device_event_2.recorded_at.iso8601, all_device_events[1]['recorded_at']
    end

    test "get all device events when empty" do
      DeviceEvent.delete_all

      get "/api/v1/device_events"
      assert_response :ok

      all_device_events = JSON.parse(response.body)
      assert_empty all_device_events
    end

  end
  
end