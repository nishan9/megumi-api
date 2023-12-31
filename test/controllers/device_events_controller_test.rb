# frozen_string_literal: true

require 'test_helper'

class DeviceEventsControllerTest < ActionDispatch::IntegrationTest
  class DeviceEventsCreateTest < DeviceEventsControllerTest
    test 'create valid device event with valid parameters' do
      post '/api/v1/device_events', params: { device_event: { category: 'device-tracking', recorded_at: Date.current } }
      assert_response :ok
      device_event = JSON.parse(response.body)
      assert_not_nil device_event['uuid']
      assert_equal 'device-tracking', device_event['category']
    end

    test 'create invalid device event with missing category parameter' do
      post '/api/v1/device_events', params: { device_event: { recorded_at: Date.current } }
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { 'category' => ["can't be blank", 'is not included in the list'] }
      assert_equal expected_error_message, error_message
    end

    test 'create invalid device event with missing recorded_at parameter' do
      post '/api/v1/device_events', params: { device_event: { category: 'device-online' } }
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { 'recorded_at' => ["can't be blank"] }
      assert_equal expected_error_message, error_message
    end
  end

  class DeviceEventsUpdateNotificationTest < DeviceEventsControllerTest
    test 'update notification_sent attribute to true when set to false' do
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.today)
      patch "/api/v1/device_events/#{device_event.uuid}"
      assert_response :ok
      updated_device_event = JSON.parse(response.body)
      assert_equal updated_device_event['notification_sent'], true
    end

    test 'return not found when the event does not exist' do
      non_existent_event_uuid = 47_382
      patch "/api/v1/device_events/#{non_existent_event_uuid}"
      assert_response :not_found
    end

    test 'error when update notification_sent attribute is already true' do
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.yesterday)
      patch "/api/v1/device_events/#{device_event.uuid}"
      assert_response :ok
      patch "/api/v1/device_events/#{device_event.uuid}"
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { 'error' => 'Notification has already been sent for this event' }
      assert_equal expected_error_message, error_message
    end
  end

  class DeviceEventsGetTest < DeviceEventsControllerTest
    test 'get device event' do
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.yesterday)
      get "/api/v1/device_events/#{device_event.uuid}"
      assert_response :ok
      assert_equal 'device-online', device_event['category']
      assert_equal device_event.uuid, device_event['uuid']
      assert_equal false, device_event['is_deleted']
      assert_equal false, device_event['notification_sent']
    end

    test 'get non existent event' do
      non_existent_event_uuid = 47_382
      get "/api/v1/device_events/#{non_existent_event_uuid}"
      assert_response :not_found
    end
  end

  class DeviceEventsGetAllTest < DeviceEventsControllerTest
    test 'get all device events' do
      DeviceEvent.delete_all
      DeviceEvent.create(category: 6, recorded_at: Date.today)
      DeviceEvent.create(category: 7, recorded_at: Date.yesterday)

      get '/api/v1/device_events'
      JSON.parse(response.body)
    end

    test 'get all device events when empty' do
      DeviceEvent.delete_all

      get '/api/v1/device_events'
      assert_response :ok

      all_device_events = JSON.parse(response.body)
      assert_empty all_device_events
    end
  end

  class DeviceEventsDeleteTest < DeviceEventsControllerTest
    test 'update is_deleted attribute to true when set to false' do
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.today)
      delete "/api/v1/device_events/#{device_event.uuid}"
      assert_response :no_content
    end

    test 'return not found when the event does not exist' do
      non_existent_event_uuid = 47_382
      delete "/api/v1/device_events/#{non_existent_event_uuid}"
      assert_response :not_found
    end

    test 'error when update is_deleted attribute is already true' do
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.yesterday)
      delete "/api/v1/device_events/#{device_event.uuid}"
      assert_response :no_content
      delete "/api/v1/device_events/#{device_event.uuid}"
      assert_response :unprocessable_entity
      error_message = JSON.parse(response.body)
      expected_error_message = { 'error' => 'This event has already been deleted' }
      assert_equal expected_error_message, error_message
    end
  end

  class DeviceEventsGetAllWithFiltersTest < DeviceEventsControllerTest
    test 'get only device events with is_deleted set to true' do
      DeviceEvent.delete_all
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.today)
      delete "/api/v1/device_events/#{device_event.uuid}"

      DeviceEvent.create(category: 'device-online', recorded_at: Date.yesterday)
      get '/api/v1/device_events?is_deleted=true'

      assert_response :ok
      deleted_device_events = JSON.parse(response.body)
      assert_equal 1, deleted_device_events.length
    end

    test 'get only device events with notification_sent set to true' do
      DeviceEvent.delete_all
      device_event = DeviceEvent.create(category: 'device-online', recorded_at: Date.today)
      patch "/api/v1/device_events/#{device_event.uuid}"

      DeviceEvent.create(category: 'device-online', recorded_at: Date.yesterday)
      get '/api/v1/device_events?notification_sent=true'

      assert_response :ok
      deleted_device_events = JSON.parse(response.body)
      assert_equal 1, deleted_device_events.length
    end
  end
end
