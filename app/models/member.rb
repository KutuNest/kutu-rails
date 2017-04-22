class Member < ApplicationRecord

  include Members::Translator
  include Members::Generator
  include Members::Trx

  Roles = {
    super_admin: 'SA', # Have privilege to all groups
    group_admin: 'GA', # Have privelege to his own group
    regular_member: 'RM' # Have privilege to his all accounts
  }

  belongs_to :country, required: false
  belongs_to :bank, required: false
  belongs_to :groupement, required: false

  has_many :accounts, dependent: :nullify

  scope :super_admin, -> {where(role: Roles[:super_admin])}
  scope :group_admin, -> {where(role: Roles[:group_admin])}
  scope :regular_member, -> {where(role: Roles[:regular_member])}

  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, #:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  #validates :account_holder_name, :bank_name, presence: true
  #validates :country, presence: true
  #validates :country_id, :bank_id, presence: true
  #validates :account_holder_name, presence: true
  #validates :account_number, presence: true, uniqueness: {scope: :bank_id}
  #validates :first_name, :last_name, presence: true

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :username, presence: true, uniqueness: true
  validates :phone_number, allow_blank: true, format: {with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i}
  phony_normalize :phone_number, default_country_code: 'MY'
  
  validates :role, presence: true, inclusion: {in: Roles.values}

  before_validation :set_defaults
  before_create :set_accounts_limit

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

  def can_add_account?
    unless self.super_admin?
      self.accounts_limit.to_i > self.accounts.count
    end
  end

private
  def set_defaults
    self.groupement = Groupement.default if self.groupement.blank? and !self.super_admin?

    if self.new_record?
      self.role = Roles[:regular_member] if self.role.blank?
      self.sms_notification = true if self.sms_notification.blank?
      self.email_notification = true if self.email_notification.blank?
    end  
  end

  def set_accounts_limit
    self.accounts_limit = self.groupement.initial_accounts.to_i if self.accounts_limit.blank? and !self.super_admin?
  end

end
