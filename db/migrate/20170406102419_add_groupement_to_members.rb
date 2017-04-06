class AddGroupementToMembers < ActiveRecord::Migration[5.0]
  def change
    add_reference :members, :groupement, foreign_key: true
  end
end
