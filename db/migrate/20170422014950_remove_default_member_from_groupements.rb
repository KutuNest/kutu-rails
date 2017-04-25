class RemoveDefaultMemberFromGroupements < ActiveRecord::Migration[5.0]
  def change
    remove_reference :groupements, :default_member
  end
end
