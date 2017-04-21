class Transaction < ApplicationRecord

  include Transactions::Status

  DisputeLimit = 3.days

  #TODO: remove member_id here

  belongs_to :eater, class_name: 'Account', foreign_key: 'eater_id'
  belongs_to :feeder, class_name: 'Account', foreign_key: 'feeder_id'
  belongs_to :member
  belongs_to :pool

  default_scope { where("member_id is not null") }

  has_many :notifications, dependent: :nullify

  has_and_belongs_to_many :accounts

  before_validation :set_defaults

  scope :success, -> { where(admin_confirmed: true, sender_confirmed: true, receiver_confirmed: true) }
  scope :pending, -> { where(sender_confirmed: false).or(Transaction.where(receiver_confirmed: false)) }
  scope :failed, -> { where(failed: true) }
  scope :disputed, -> { where(disputed: true) }

  validates :eater_id, :feeder_id, presence: true
  validates :timeout, :value, numericality: true, presence: true

  after_save :proceed_completed

  mount_uploader :sender_receipt, ReceiptUploader

  def counter_part(m)
    self.eater.member == m ? self.feeder : self.eater
  end

  class << self
    def by_member(m)
      account_ids = m.accounts.map(&:id)
      self.where(eater_id: account_ids).or(self.where(feeder_id: account_ids))
    end
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
      self.sender_confirmed = false
      self.receiver_confirmed = false
      self.admin_confirmed = false
      self.failed = false
      self.disputed = false
      self.completed_date = false
    end
  end  

end
