class RemoveMembersColumnOnGroupements < ActiveRecord::Migration[5.0]
  def change
    remove_column :groupements, :default_account_holder_name
    remove_column :groupements, :default_account_number
    remove_column :groupements, :default_bank_name
  end
end
