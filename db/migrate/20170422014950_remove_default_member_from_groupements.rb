class RemoveDefaultMemberFromGroupements < ActiveRecord::Migration[5.0]
  def change
    remove_reference :groupements, :default_member, foreign_key: true
  end
end
