class AddSenderReceiptToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :sender_receipt, :string
  end
end
