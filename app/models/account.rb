# Moved columns:
# Account -> Member
# - admin_account
# - group_id
# - super_user
# 
# Transaction (added)
# - pool_id 
#
# To be removed:
# - member_id
# 

class Account < ApplicationRecord

  include Accounts::Flow
  include Accounts::Populator

  #TODO: ensure assignment not on kicked out accounts

  attr_accessor :auto_create_transaction

  belongs_to :member
  belongs_to :groupement
  belongs_to :pool

  has_many :notifications, dependent: :nullify

  #has_and_belongs_to_many :a_transactions, class_name: 'Transaction', dependent: :nullify

  has_many :transaction_feeders, class_name: 'Transaction', foreign_key: 'feeder_id'
  has_many :transaction_eaters, class_name: 'Transaction', foreign_key: 'eater_id'

  scope :active, -> { where(has_finished: false, kicked_out: false) }
  scope :completed, -> { where(has_finished: true, kicked_out: false) }
  scope :kicked_out, -> { where(kicked_out: true) }

  scope :feeder, -> {where(action_available: true)}
  scope :eater, -> {where(action_available: false)}

  validates :pool_id, presence: true
  validates :member_id, presence: true
  validates :name, presence: true, uniqueness: {scope: :member_id}

  def transaction_scope
    Transaction.where("eater_id = ? OR feeder_id = ?", self.id, self.id).order("created_at desc")
  end

  def transaction_history
    completed_transactions.to_a + failed_transactions.to_a
  end

  def pending_transactions
    (sending_transactions.to_a + receiving_transactions.to_a + disputed_transactions.to_a).uniq
  end

  def completed_transactions
    transaction_scope.where(sender_confirmed: true, receiver_confirmed: true, admin_confirmed: true)
  end

  def disputed_transactions
    transaction_scope.where(disputed: true)
  end

  def failed_transactions
    transaction_scope.where(failed: true)
  end  

  def receiving_transactions
    Transaction.where("eater_id = ? AND pool_id = ?", self.id, self.pool.id).order("created_at desc").where("sender_confirmed = ? OR receiver_confirmed = ?", false, false)
  end

  def sending_transactions
    Transaction.where("feeder_id = ? AND pool_id = ?", self.id, self.pool.id).order("created_at desc").where("sender_confirmed = ? OR receiver_confirmed = ?", false, false)
  end

  def kick_out!
    self.kicked_out = true
    self.number_associations_left = 0
    self.save
    self.member.lock_access!
    notify_has_finished
  end

  def change_pool_order!(order)
    for a in self.pool.accounts do
      if a.pool_order.to_i >= order.to_i
        a.pool_order = a.pool_order.to_i + 1
      elsif a.pool_order.to_i < order.to_i
        a.pool_order = a.pool_order + 1
      end
      a.save
    end

    self.pool_order = order.to_i
    self.save
  end

  def summary
    {
      total_sent: Transaction.where(feeder_id: self.id, sender_confirmed: true).sum{|a| a.value },
      total_received: Transaction.where(eater_id: self.id, sender_confirmed: true).sum{|a| a.value },
      total_transaction: Transaction.where(eater_id: self.id).or(Transaction.where(feeder_id: self.id)).count,
      total_failed: Transaction.where(eater_id: self.id).or(Transaction.where(feeder_id: self.id)).where(failed: true).count
    }
  end

  def notify_has_finished
    Notification.create(
      transaction_id: nil,
      account_id: self.id,
      notification_event: Notification::Events[:has_finished], 
      receiver_email: self.member.email, 
      receiver_mobile_number: self.member.phone_number)
  end

end
