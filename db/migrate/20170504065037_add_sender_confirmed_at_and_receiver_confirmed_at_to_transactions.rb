class AddSenderConfirmedAtAndReceiverConfirmedAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :sender_confirmed_at, :datetime
    add_column :transactions, :receiver_confirmed_at, :datetime
  end
end
