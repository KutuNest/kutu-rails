class Pool < ApplicationRecord
  belongs_to :groupement

  has_many :p_transactions, class_name: 'Transaction', foreign_key: 'pool_id', dependent: :nullify
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

  def first_target(acc)
    accs = self.accounts.active.where.not(id: acc.id).order(:pool_order)
    target = nil
    for a in accs do
      if Transaction.where(failed: false, pool_id: self.id, eater_id: a.id).count < self.feeders_count
        if Transaction.where("eater_id = ? OR feeder_id = ?", a.id, a.id).where(pool_id: self.id, disputed: true).to_a.size.zero?
          if Transaction.where(pool_id: self.id, feeder_id: a.id, sender_confirmed: true, receiver_confirmed: true, admin_confirmed: true).any? or a.super_user?
            target = a
            break
          end
        end
      end
    end
    target
  end

end
