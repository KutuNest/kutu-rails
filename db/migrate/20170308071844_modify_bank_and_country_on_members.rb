class ModifyBankAndCountryOnMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :country
    remove_column :members, :bank_name
    
    add_column :members, :country_id, :integer
    add_column :members, :bank_id, :integer
  end
end
