class AddPoolToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :pool, foreign_key: true
  end
end
