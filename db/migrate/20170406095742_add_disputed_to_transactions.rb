class AddDisputedToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :dispute, :boolean
  end
end
