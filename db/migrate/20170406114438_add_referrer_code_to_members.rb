class AddReferrerCodeToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :referrer_code, :string
  end
end
