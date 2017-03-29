class AddMemberToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :member, foreign_key: true
  end
end
