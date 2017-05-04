class Transaction < ApplicationRecord

  include Transactions::Status

  DisputeLimit = 4.days
  #DisputeLimit = 1.hour

  attr_accessor :proceed_to_parties

  belongs_to :eater, class_name: 'Account', foreign_key: 'eater_id'
  belongs_to :feeder, class_name: 'Account', foreign_key: 'feeder_id'
  belongs_to :pool

  has_many :notifications, dependent: :nullify

  before_validation :set_defaults

  scope :success, -> { where(admin_confirmed: true, sender_confirmed: true, receiver_confirmed: true) }
  scope :pending, -> { where(sender_confirmed: false).or(Transaction.where(receiver_confirmed: false)) }
  scope :failed, -> { where(failed: true) }
  scope :disputed, -> { where(disputed: true) }

  validates :eater_id, :feeder_id, presence: true
  validates :timeout, :value, numericality: true, presence: true

  after_save :proceed_completed #, if: :proceed_to_parties

  mount_uploader :sender_receipt, ReceiptUploader

  def counter_part(m)
    self.eater.member == m ? self.feeder : self.eater
  end

  class << self
    def by_member(m)
      account_ids = m.accounts.map(&:id)
      self.where(eater_id: account_ids).or(self.where(feeder_id: account_ids))
    end

    def disputed_by_timeout!
      trxs = Transaction.where(disputed: false, failed: false, sender_confirmed: false, admin_confirmed: false, receiver_confirmed: false)
      for t in trxs do
        if (t.created_at + DisputeLimit) < Time.zone.now
          t.disputed = true
          t.save
        end
      end

      trxs = Transaction.where(disputed: false, failed: false, sender_confirmed: true, admin_confirmed: false, receiver_confirmed: false)
      for t in trxs do
        if (t.sender_confirmed_at + DisputeLimit) < Time.zone.now
          t.disputed = true
          t.save
        end
      end      
    end

    def update_confirmation_dates
      trxs = Transaction.where(sender_confirmed: true, receiver_confirmed: false)
      for t in trxs do
        t.sender_confirmed_at = t.updated_at
        t.save
      end

      trxs = Transaction.where(sender_confirmed: true, receiver_confirmed: true)
      for t in trxs do
        t.receiver_confirmed_at = t.updated_at
        t.save
      end
    end
  end

  def dispute_allowed?
    if confirmed?
      if self.completed_date.present?
        (self.completed_date + DisputeLimit) < Time.zone.now.to_date
      end
    elsif self.sender_confirmed? and (self.created_at + DisputeLimit) < Time.zone.now.to_date
      true
    elsif disputed?
      false
    end
  end

  def notify_sender_confirmed
    self.notifications.create(
      account_id: self.eater.id,
      notification_event: Notification::Events[:sender_confirmed], 
      receiver_email: self.eater.member.email, 
      receiver_mobile_number: self.eater.member.phone_number)    
  end

  def notify_new_transaction
    self.notifications.create(
      account_id: self.feeder.id,
      notification_event: Notification::Events[:new_transaction], 
      receiver_email: self.feeder.member.email, 
      receiver_mobile_number: self.feeder.member.phone_number) 
        
    self.notifications.create(
      account_id: self.eater.id,
      notification_event: Notification::Events[:new_transaction], 
      receiver_email: self.eater.member.email, 
      receiver_mobile_number: self.eater.member.phone_number)         
  end

  def notify_receiver_confirmed
    self.notifications.create(
      account_id: self.feeder.id,
      notification_event: Notification::Events[:receiver_confirmed], 
      receiver_email: self.feeder.member.email, 
      receiver_mobile_number: self.feeder.member.phone_number)        
  end

  def notify_disputed
    self.notifications.create(
      account_id: self.feeder.id,
      notification_event: Notification::Events[:disputed], 
      receiver_email: self.feeder.member.email, 
      receiver_mobile_number: self.feeder.member.phone_number)        
  end

  def notify_failed
    self.notifications.create(
      account_id: self.feeder.id,
      notification_event: Notification::Events[:failed], 
      receiver_email: self.feeder.member.email, 
      receiver_mobile_number: self.feeder.member.phone_number)        
  end

  def notify_resolved
    self.notifications.create(
      account_id: self.feeder.id,
      notification_event: Notification::Events[:resolved], 
      receiver_email: self.feeder.member.email, 
      receiver_mobile_number: self.feeder.member.phone_number)        
  end

private

  def proceed_completed
    if confirmed?
      self.eater.proceed_last_transaction! 
      self.feeder.proceed_last_transaction!

      self.update_columns(completed_date: Date.today)
    end
  end

  def set_defaults
    if self.new_record?
      self.sender_confirmed = false if self.sender_confirmed.blank?
      self.receiver_confirmed = false if self.receiver_confirmed.blank?
      self.admin_confirmed = false if self.admin_confirmed.blank?
      self.failed = false if self.failed.blank?
      self.disputed = false if self.disputed.blank?
      self.completed_date = nil if self.completed_date.blank?
    end
  end  

end
