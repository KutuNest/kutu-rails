class Pool < ApplicationRecord
  belongs_to :groupement

  validates :groupement_id, presence: true
  validates :title, presence: true, uniqueness: {scope: :groupement_id}
  validates :amount, :position, :feeders_count, :timeout, numericality: true, presence: true
end
