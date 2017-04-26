class ModifyNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :body, :string
    remove_column :notifications, :sender_email, :string
    remove_column :notifications, :short_body, :string
    remove_column :notifications, :title, :string
    remove_column :notifications, :notification_type, :string
    add_column :notifications, :member_id, :integer
  end
end
