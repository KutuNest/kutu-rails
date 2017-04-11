class AddPoolToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :pool, foreign_key: true
  end
end
