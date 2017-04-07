class RenameAckColumnsOnTransactions < ActiveRecord::Migration[5.0]
  def change
  	rename_column :transactions, :sender_ack, :sender_confirmed
  	rename_column :transactions, :receiver_ack, :receiver_confirmed
  end
end
