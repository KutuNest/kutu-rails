class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :member, foreign_key: true
      t.string :name
      t.date :arrival_date
      t.boolean :admin_account
      t.boolean :super_user
      t.boolean :action_available
      t.boolean :kicked_out
      t.integer :number_associations_left

      t.timestamps
    end
  end
end
