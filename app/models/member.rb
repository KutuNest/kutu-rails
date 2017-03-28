class Member < ApplicationRecord

  Roles = {
    super_admin: 'SA', # Have privilege to all groups
    group_admin: 'GA', # Have privelege to his own group
    regular_member: 'RM' # Have privilege to his all accounts
  }

  belongs_to :country
  belongs_to :bank

  has_one :groupement, foreign_key: 'default_member_id'

  has_many :accounts, dependent: :nullify

  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  #validates :account_holder_name, :bank_name, presence: true
  #validates :country, presence: true
  validates :country_id, :bank_id, presence: true

  validates :account_holder_name, presence: true
  validates :account_number, presence: true, uniqueness: {scope: :bank_id}

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :phone_number, presence: true, format: {with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i}
  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: {in: Roles.values}

  def enter_pool
  end

  def send_money
  end

end
