class AddUniqueIndexOnAccounts < ActiveRecord::Migration[5.0]
  def change
    add_index(:accounts, [:member_id, :name], :unique => true)
  end
end
