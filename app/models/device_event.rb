class DeviceEvent < ApplicationRecord

    before_create :set_received_at
    validates :category, :recorded_at, presence: true
    attr_readonly :received_at
    after_initialize :init
    validates :device_uuid, allow_nil: true, format: {
        with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i,
        message: "has an incorrect format"
    }
    validates :category, inclusion: {
    in: [
      "device-incident",
      "device-tracking",
      "device-exited-home",
      "device-home",
      "device-overheating",
      "device-charging-completed",
      "device-charging",
      "device-battery-low",
      "device-online",
      "device-offline",
      "device-heartbeat",
      "device-pairing-start"
    ]
  }

    scope :filter_by_params, -> (params) {
        filtered_events = all

        if params[:notification_sent].present?
            filtered_events = filtered_events.where(notification_sent: params[:notification_sent])
        end
    
        if params[:is_deleted].present?
            filtered_events = filtered_events.where(is_deleted: params[:is_deleted])
        end
    
        filtered_events
    }

    def set_received_at
        self.received_at = Time.current
    end

    private 

    def init
        self.is_deleted = false if self.is_deleted.nil?
        self.notification_sent = false if self.notification_sent.nil?
    end
end