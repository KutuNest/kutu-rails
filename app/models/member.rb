require 'twilio-ruby'

class Member < ApplicationRecord

  include Members::Translator
  include Members::Generator
  include Members::Trx

  Roles = {
    super_admin: 'SA', # Have privilege to all groups
    group_admin: 'GA', # Have privelege to his own group
    regular_member: 'RM' # Have privilege to his all accounts
  }

  attr_accessor :skip_referrer_code

  belongs_to :country, required: false
  belongs_to :bank, required: false
  belongs_to :groupement, required: false

  has_many :accounts, dependent: :nullify
  has_many :notifications, dependent: :nullify

  scope :super_admin, -> {where(role: Roles[:super_admin])}
  scope :group_admin, -> {where(role: Roles[:group_admin])}
  scope :regular_member, -> {where(role: Roles[:regular_member])}

  devise :database_authenticatable, :registerable, :lockable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :username, presence: true, uniqueness: true
  validate :referrer_code_match, unless: :skip_referrer_code
  validates :phone_number, allow_blank: true, format: {with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i}
  phony_normalize :phone_number, default_country_code: 'MY'
  
  validates :role, presence: true, inclusion: {in: Roles.values}

  before_validation :set_defaults
  before_create :set_accounts_limit

  after_create :send_welcome_sms

  def send_welcome_sms
    n = self.notifications.where(notification_event: Notification::Events[:welcome_sms]).first
    if n.present?
      if n.status == Notification::Statuses[:delivered]
        true
      else
        if n.deliver_sms
          n.status = Notification::Statuses[:delivered]
          n.save
        end
      end
    else
      self.notifications.create(
        transaction_id: nil,
        notification_event: Notification::Events[:welcome_sms], 
        receiver_email: self.email, 
        receiver_mobile_number: self.phone_number)          
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

  def can_add_account?
    unless self.super_admin?
      self.accounts_limit.to_i > self.accounts.count
    end
  end

  def referrer_code_match
    if self.role != Roles[:super_admin]
      if self.referrer_code.blank?
        errors.add :referrer_code, "should not be blank"
      elsif Member.where(referral_code: self.referrer_code).size.zero?
        errors.add :referrer_code, "need a valid referral code. Please ask to <a href='mailto:referrals@playkutu.com'>referrals@playkutu.com</a>"
      end
    end
  end

  def cycle_completed?
    self.accounts.map {|a| a.has_finished_group? }.find {|a| a == true }
  end      

  def notify_limit_changed
    Notification.create(
      transaction_id: nil,
      account_id: nil,
      notification_event: Notification::Events[:limit_changed], 
      receiver_email: self.email, 
      receiver_mobile_number: self.phone_number)    
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
