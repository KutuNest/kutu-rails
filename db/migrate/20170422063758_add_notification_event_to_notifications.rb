class AddNotificationEventToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :notification_event, :string
  end
end
