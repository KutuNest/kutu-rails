class AddRoleToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :role, :string
  end
end
