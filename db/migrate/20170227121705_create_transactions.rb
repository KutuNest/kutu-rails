class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :eater_id
      t.integer :feeder_id
      t.date :completed_date
      t.integer :value
      t.integer :timeout
      t.boolean :sender_ack
      t.boolean :receiver_ack
      t.boolean :failed
      t.boolean :admin_confirmed

      t.timestamps
    end
  end
end
