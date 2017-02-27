class AddGroupementToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :groupement, foreign_key: true
  end
end
