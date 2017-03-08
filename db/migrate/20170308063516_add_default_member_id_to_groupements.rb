class AddDefaultMemberIdToGroupements < ActiveRecord::Migration[5.0]
  def change
    add_column :groupements, :default_member_id, :integer
  end
end
