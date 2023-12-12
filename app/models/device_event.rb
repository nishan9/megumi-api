class DeviceEvent < ApplicationRecord
    before_create :set_received_at

    validates :category, :recorded_at, presence: true
    attr_readonly :received_at
    validate :attributes_not_set_at_creation

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
end