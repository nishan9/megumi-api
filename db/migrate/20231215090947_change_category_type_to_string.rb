class ChangeCategoryTypeToString < ActiveRecord::Migration[7.1]
  def change
    change_column :device_events, :category, :string
  end
end
