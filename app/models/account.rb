class Account < ApplicationRecord
  DefaultNumberAssociations = 4

  belongs_to :member
  belongs_to :groupement
  belongs_to :pool

  has_many :notifications

  has_and_belongs_to_many :accounts

  has_many :transaction_feeders, class_name: 'Transaction', foreign_key: 'feeder_id'
  has_many :transaction_eaters, class_name: 'Transaction', foreign_key: 'eater_id'

  scope :active, -> { where(kicked_out: false) }

  before_validation :set_defaults

  validates :pool_id, presence: true
  validates :groupement_id, presence: true
  validates :member_id, presence: true
  validates :name, presence: true, uniqueness: {scope: :member_id}
  

private

  def set_defaults
    if self.new_record?
      self.admin_account = false if self.admin_account.blank?
      self.super_user = false if self.super_user.blank?
      self.action_available = false if self.action_available.blank?
      self.kicked_out = false if self.kicked_out.blank?
      self.number_associations_left = DefaultNumberAssociations if self.number_associations_left.blank?
    end
  end

end
