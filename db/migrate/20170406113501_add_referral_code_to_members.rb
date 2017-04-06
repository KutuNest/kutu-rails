class AddReferralCodeToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :refferal_code, :string
  end
end
