class RemoveDeviseOnGroupments < ActiveRecord::Migration[5.0]
  def change
    remove_column :groupements, :default_member_id
    remove_column :groupements, :email
    remove_column :groupements, :name
    remove_column :groupements, :username

    remove_column :groupements, :encrypted_password

    ## Recoverable
    remove_column :groupements, :reset_password_token
    remove_column :groupements, :reset_password_sent_at

    ## Rememberable
    remove_column :groupements, :remember_created_at

    ## Trackable
    remove_column :groupements, :sign_in_count
    remove_column :groupements, :current_sign_in_at
    remove_column :groupements, :last_sign_in_at
    remove_column :groupements, :current_sign_in_ip
    remove_column :groupements, :last_sign_in_ip

    ## Confirmable
    remove_column :groupements, :confirmation_token
    remove_column :groupements, :confirmed_at
    remove_column :groupements, :confirmation_sent_at
    remove_column :groupements, :unconfirmed_email # Only if using reconfirmable

    ## Lockable
    remove_column :groupements, :failed_attempts # Only if lock strategy is :failed_attempts
    remove_column :groupements, :unlock_token # Only if unlock strategy is :email or :both
    remove_column :groupements, :locked_at


    add_column :groupements, :title, :string


    #remove_index :groupements, :email
    #remove_index :groupements, :reset_password_token  
  end
end
