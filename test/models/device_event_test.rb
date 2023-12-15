require "test_helper"

class DeviceEventTest < ActiveSupport::TestCase

  test 'create valid device event' do
    device_event = DeviceEvent.new(recorded_at: Date.today, device_uuid: "755d3a5e-9b31-11ee-b9d1-0242ac120002", category: "device-online")
    puts device_event.received_at
    assert device_event.valid?
  end

  test 'create invalid device event missing recorded_at' do
    device_event = DeviceEvent.new(device_uuid: "755d3a5e-9b31-11ee-b9d1-0242ac120002", category: "device-online")
    assert_not device_event.valid?
  end

  test 'create invalid device event missing category' do
    device_event = DeviceEvent.new(recorded_at: Date.today, device_uuid: "755d3a5e-9b31-11ee-b9d1-0242ac120002")
    puts device_event.received_at
    assert_not device_event.valid?
  end

  test 'create invalid device event with incorrectly formatted device_uuid set at creation' do
    device_event = DeviceEvent.new(recorded_at: Date.today, received_at: Date.today, device_uuid: "hi", category: "device-online")
    assert_not device_event.valid?
  end

end
