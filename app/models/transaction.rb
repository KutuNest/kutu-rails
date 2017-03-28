class Transaction < ApplicationRecord

  belongs_to :eater, class_name: 'Account', foreign_key: 'eater_id'
  belongs_to :feeder, class_name: 'Account', foreign_key: 'feeder_id'

  has_many :notifications

  has_and_belongs_to_many :accounts

  before_validation :set_defaults

  validates :eater_id, :feeder_id, presence: true
  validates :completed_date, presence: true
  validates :timeout, :value, numericality: true, presence: true

  mount_uploader :sender_receipt, ReceiptUploader
  
  def confirmed?
    sender_ack? and receiver_ack? and admin_confirmed?
  end

private
  def set_defaults
    if self.new_record?
      self.sender_ack = false if self.sender_ack.blank?
      self.receiver_ack = false if self.receiver_ack.blank?
      self.failed = false if self.failed.blank?
      self.admin_confirmed = false if self.admin_confirmed.blank?
    end
  end  

end
