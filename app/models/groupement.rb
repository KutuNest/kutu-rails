class Groupement < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :default_account_holder_name, :bank_name, presence: true
  validates :default_account_number, :default_bank_name, presence: true
  validates :default_member_id, presence: true

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :username, :name, presence: true

  validates :initial_accounts, :maximum_accounts, :accounts_added_on_success, presence: true, numericality: true

  
end
