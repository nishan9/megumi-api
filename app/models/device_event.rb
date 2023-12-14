class DeviceEvent < ApplicationRecord

    before_create :set_received_at
    validates :category, :recorded_at, presence: true
    attr_readonly :received_at
    validate :attributes_not_set_at_creation
    after_initialize :init

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

    def attributes_not_set_at_creation
        if new_record?
            if notification_sent.present? || is_deleted.present? || received_at.present?
                errors.add(:base, "notification_sent, is_deleted or received_at cannot be set at creation")
            end
        end
    end
    def init
        self.is_deleted = false if self.is_deleted.nil?
        self.notification_sent = false if self.notification_sent.nil?
    end
end