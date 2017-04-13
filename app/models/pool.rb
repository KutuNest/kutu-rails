class Pool < ApplicationRecord
  belongs_to :groupement

  has_many :p_transactions, class_name: 'Transaction', foreign_key: 'pool_id'
  has_many :accounts, dependent: :nullify

  validates :groupement_id, presence: true
  validates :title, presence: true, uniqueness: {scope: :groupement_id}
  validates :amount, :feeders_count, :timeout, numericality: true, presence: true
  validates :position, presence: true, numericality: true, uniqueness: {scope: :groupement_id}

  def last_group_pool?
    self.position == Pool.where(groupement_id: self.groupement_id).maximum(:position)
  end

  def next_pool
    Pool.where(groupement_id: self.groupement_id, position: (self.position + 1)).first
  end

  def first_target
    self.accounts
  end

end
