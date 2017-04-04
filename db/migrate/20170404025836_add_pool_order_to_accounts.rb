class AddPoolOrderToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :pool_order, :integer
  end
end
