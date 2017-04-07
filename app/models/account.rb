# Moved columns:
# - admin_account
# - group_id
# - super_user

class Account < ApplicationRecord
  DefaultNumberAssociations = 4

  belongs_to :member
  belongs_to :groupement
  belongs_to :pool

  has_many :notifications, dependent: :nullify

  has_and_belongs_to_many :a_transactions, class_name: 'Transaction', dependent: :nullify

  has_many :transaction_feeders, class_name: 'Transaction', foreign_key: 'feeder_id'
  has_many :transaction_eaters, class_name: 'Transaction', foreign_key: 'eater_id'

  scope :active, -> { where(kicked_out: false) }
  scope :completed, -> { where(kicked_out: true) }

  scope :feeder, -> {where(action_available: true)}
  scope :eater, -> {where(action_available: false)}

  validates :pool_id, presence: true
  #validates :groupement_id, presence: true
  validates :member_id, presence: true
  validates :name, presence: true, uniqueness: {scope: :member_id}

  before_validation :set_defaults
  after_create :create_default_transaction
  
  def change_pool_order!(order)
    self.pool_order = order
    #TODO: other account order
    self.save
  end

  def auto_populate(pool)
    self.pool = pool
    self.groupement = pool.groupement if pool.present?
    generate_account_id
  end

private
  def create_default_transaction
    transaction = self.a_transactions.new
    transaction.member = self.member
    transaction.timeout = DateTime.now + self.pool.timeout.to_i.seconds
    transaction.value = self.pool.amount

    #TODO: set correct account match
    if self.super_user?
      transaction.eater  = self
      transaction.feeder = self.pool.accounts.last
    else
      transaction.feeder = self
      transaction.eater  = self.pool.accounts.last
    end
    transaction.save
  end

  def set_defaults
    if self.new_record?
      self.kicked_out = false

      self.super_user = false if self.super_user.blank?
      self.action_available = false if self.action_available.blank?
      self.number_associations_left = DefaultNumberAssociations if self.number_associations_left.blank?
    end
  end

  def generate_account_id
    accounts = self.member.accounts.map{|a| a.name.to_i }.sort
    if accounts.any?
      self.name = self.member.username + "_#{accounts.last + 1}"
    else
      self.name = self.member.username + "_#{0}"
    end
  end

end
