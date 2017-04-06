class AddAccountsLimitToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :accounts_limit, :integer
  end
end
