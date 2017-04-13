class Member < ApplicationRecord

  include Members::Translator
  include Members::Generator

  Roles = {
    super_admin: 'SA', # Have privilege to all groups
    group_admin: 'GA', # Have privelege to his own group
    regular_member: 'RM' # Have privilege to his all accounts
  }

  belongs_to :country, required: false
  belongs_to :bank, required: false

  has_one :groupement, foreign_key: 'default_member_id'

  has_many :accounts, dependent: :nullify
  has_many :transactions, dependent: :nullify

  scope :super_admin, -> {where(role: Roles[:super_admin])}
  scope :group_admin, -> {where(role: Roles[:group_admin])}
  scope :regular_member, -> {where(role: Roles[:regular_member])}

  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  #validates :account_holder_name, :bank_name, presence: true
  #validates :country, presence: true
  #validates :country_id, :bank_id, presence: true
  #validates :account_holder_name, presence: true
  #validates :account_number, presence: true, uniqueness: {scope: :bank_id}
  #validates :first_name, :last_name, presence: true

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :phone_number, allow_blank: true, format: {with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i}
  
  validates :role, presence: true, inclusion: {in: Roles.values}
  validates :username, presence: true

  before_validation :set_default_role

  def bank_info_completed?
    self.account_holder_name.present? and self.account_number.present? and self.bank_id.present?
  end

  def send_money(account_feeder, account_eater)
    t = Transaction.where(eater_id: account_eater.id, feeder_id: self.account_feeder.id).first
    if t.present?
      t.sender_ack = true
      t.save
    end
  end

  def current_transaction(account=nil)
    account = self.accounts.first if account.nil?
    if account and account.member_id == self.id
      Transaction.where(feeder_id: account.id, admin_confirmed: true).first
    end
  end

  def transaction_history(account=nil)
    account = self.accounts.first if account.nil?
    if account and account.member_id == self.id
      Transaction.where(feeder_id: account.id, admin_confirmed: false)
    end
  end

  def summary
    {
      total_accounts: self.accounts.count,
      active_accounts: self.accounts.active.count,
      inactive_accounts: self.accounts.count - self.accounts.active.count,
      total_transaction: Transaction.where(feeder_id: self.accounts.map(&:id)).count,
      pending_transaction: Transaction.where(feeder_id: self.accounts.map(&:id)).pending.count,
      failed_transaction: Transaction.where(feeder_id: self.accounts.map(&:id)).failed.count,
      money_sent: Transaction.where(feeder_id: self.accounts.map(&:id)).sum(&:value),
      money_received: Transaction.where(eater_id: self.accounts.map(&:id)).sum(&:value)
    }
  end  

private
  def set_default_role
    self.role = Roles[:regular_member] if self.role.blank?
  end

end
