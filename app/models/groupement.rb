class Groupement < ApplicationRecord
  belongs_to :default_member, class_name: 'Member', foreign_key: 'default_member_id', required: false

  has_many :pools, dependent: :nullify
  has_many :members, dependent: :nullify

  validates :title, presence: true, uniqueness: true
  validates :initial_accounts, :maximum_accounts, :accounts_added_on_success, presence: true, numericality: true

  def first_pool
    Pool.where(groupement_id: self.id, position: self.pools.minimum(:position)).first
  end

  class << self
    def default
      Groupement.first
    end

    def initial_pool
      Pool.order(:position).first
    end
  end
end
