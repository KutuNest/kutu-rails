class CreateJoinTableAccountsTransactions < ActiveRecord::Migration[5.0]
  def change
    create_join_table :accounts, :transactions do |t|
      # t.index [:account_id, :transaction_id]
      # t.index [:transaction_id, :account_id]
    end
  end
end
