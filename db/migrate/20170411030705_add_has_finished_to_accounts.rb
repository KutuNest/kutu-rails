class AddHasFinishedToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :has_finished, :boolean
  end
end
