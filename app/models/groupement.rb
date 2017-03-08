class Groupement < ApplicationRecord
  belongs_to :default_member, class_name: 'Member', foreign_key: 'default_member_id'

  has_many :pools

  validates :title, presence: true, uniqueness: true
  validates :initial_accounts, :maximum_accounts, :accounts_added_on_success, presence: true, numericality: true

end
