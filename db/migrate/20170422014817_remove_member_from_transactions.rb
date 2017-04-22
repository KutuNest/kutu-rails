class RemoveMemberFromTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_reference :transactions, :member, foreign_key: true
  end
end
