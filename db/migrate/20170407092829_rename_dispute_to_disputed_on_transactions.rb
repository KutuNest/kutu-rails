class RenameDisputeToDisputedOnTransactions < ActiveRecord::Migration[5.0]
  def change
  	rename_column :transactions, :dispute, :disputed
  end
end
