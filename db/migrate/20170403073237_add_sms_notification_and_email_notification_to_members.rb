class AddSmsNotificationAndEmailNotificationToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :sms_notification, :boolean
    add_column :members, :email_notification, :boolean
  end
end
