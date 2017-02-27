class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :notification_type
      t.string :title
      t.text :body
      t.belongs_to :transaction, foreign_key: true
      t.belongs_to :account, foreign_key: true
      t.string :receiver_email
      t.string :receiver_mobile_number
      t.string :sender_email
      t.string :receiver_mobile_number
      t.string :status

      t.timestamps
    end
  end
end
