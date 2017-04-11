class Pool < ApplicationRecord
  belongs_to :groupement
  has_many :accounts

  validates :groupement_id, presence: true
  validates :title, presence: true, uniqueness: {scope: :groupement_id}
  validates :amount, :position, :feeders_count, :timeout, numericality: true, presence: true

  def last_group_pool?
    self.position == Pool.where(groupement_id: self.groupement_id).maximum(:position)
  end
end
