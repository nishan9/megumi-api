# frozen_string_literal: true

class CreateDeviceEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :device_events, id: :uuid do |t|
      t.datetime :recorded_at
      t.datetime :received_at
      t.string :device_uuid
      t.jsonb :metadata
      t.boolean :notification_sent
      t.boolean :is_deleted
      t.integer :category

      t.timestamps
    end
  end
end
