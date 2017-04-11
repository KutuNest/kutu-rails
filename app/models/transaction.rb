class Transaction < ApplicationRecord

  include Transactions::Status

  belongs_to :eater, class_name: 'Account', foreign_key: 'eater_id'
  belongs_to :feeder, class_name: 'Account', foreign_key: 'feeder_id'
  belongs_to :member

  default_scope { where("member_id is not null") }

  has_many :notifications, dependent: :nullify

  has_and_belongs_to_many :accounts

  before_validation :set_defaults

  scope :success, -> { where(admin_confirmed: true) }
  scope :pending, -> { where(sender_confirmed: false).or(Transaction.where(receiver_confirmed: false)) }
  scope :failed, -> { where(failed: true) }
  scope :disputed, -> { where(disputed: true) }

  validates :eater_id, :feeder_id, presence: true
  validates :timeout, :value, numericality: true, presence: true

  after_save :handle_after_completed

  mount_uploader :sender_receipt, ReceiptUploader

private
  def handle_after_completed
    if confirmed?
      if self.account.has_finished_pool?
        enter_next_pool!
      elsif self.account.has_finished_group?
        kick_his_ass!
      else
        create_pool_transaction!
      end
    end
  end

  def enter_next_pool!

  end

  def create_pool_transactions!
  end

  def kick_his_ass!

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
