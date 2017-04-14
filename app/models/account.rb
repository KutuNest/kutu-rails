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

  belongs_to :member
  belongs_to :groupement
  belongs_to :pool

  has_many :notifications, dependent: :nullify

  has_and_belongs_to_many :a_transactions, class_name: 'Transaction', dependent: :nullify

  has_many :transaction_feeders, class_name: 'Transaction', foreign_key: 'feeder_id'
  has_many :transaction_eaters, class_name: 'Transaction', foreign_key: 'eater_id'

  scope :active, -> { where(has_finished: false) }
  scope :completed, -> { where(has_finished: true) }
  scope :kicked_out, -> { where(kicked_out: true) }

  scope :feeder, -> {where(action_available: true)}
  scope :eater, -> {where(action_available: false)}

  validates :pool_id, presence: true
  validates :member_id, presence: true
  validates :name, presence: true, uniqueness: {scope: :member_id}

  def transaction_history
    Transaction.where("eater_id = ? OR feeder_id = ?", self.id, self.id).order("created_at desc")
  end

  def change_pool_order!(order)
    for a in self.pool.accounts do
      if a >= order.to_i
        a.pool_order = a.pool_order + 1
        a.save
      end
    end

    self.pool_order = order.to_i
    self.save
  end

  def summary
    {
      total_sent: self.a_transactions.where(feeder_id: self.id, sender_confirmed: true).sum{|a| a.value },
      total_received: self.a_transactions.where(eater_id: self.id, receiver_confirmed: true).sum{|a| a.value },
      total_transaction: Transaction.where(eater_id: self.id).or(Transaction.where(feeder_id: self.id)).count,
      total_failed: Transaction.where(eater_id: self.id).or(Transaction.where(feeder_id: self.id)).where(failed: true).count
    }
  end

end
