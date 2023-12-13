require "test_helper"

class DeviceEventTest < ActiveSupport::TestCase

  test 'create valid device event' do
    device_event = DeviceEvent.new(recorded_at: Date.today, device_uuid: "342354764723", category: 2)
    puts device_event.received_at
    assert device_event.valid?
  end

  test 'create invalid device event missing recorded_at' do
    device_event = DeviceEvent.new(device_uuid: "342354764723", category: 2)
    assert_not device_event.valid?
  end

  test 'create invalid device event missing category' do
    device_event = DeviceEvent.new(recorded_at: Date.today, device_uuid: "342354764723")
    puts device_event.received_at
    assert_not device_event.valid?
  end

  test 'create invalid device event with received_at set at creation' do
    device_event = DeviceEvent.new(recorded_at: Date.today, received_at: Date.today, device_uuid: "342354764723", category: 2)
    assert_not device_event.valid?
  end

  test 'create invalid device event with notification_sent set at creation' do
    device_event = DeviceEvent.new(recorded_at: Date.today, received_at: Date.today, device_uuid: "342354764723", notification_sent: false, category: 2)
    assert_not device_event.valid?
  end

  test 'create invalid device event with is_deleted set at creation' do
    device_event = DeviceEvent.new(recorded_at: Date.today, received_at: Date.today, device_uuid: "342354764723", is_deleted: false, category: 2)
    assert_not device_event.valid?
  end
end
