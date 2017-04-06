class RenameRefferalCodeToReferrerCodeOnMembers < ActiveRecord::Migration[5.0]
  def change
  	rename_column :members, :refferal_code, :referral_code
  end
end
