# frozen_string_literal: true

class ChangeIdToUuid < ActiveRecord::Migration[7.1]
  def change
    rename_column :device_events, :id, :uuid
    change_column :device_events, :uuid, :uuid
  end
end
