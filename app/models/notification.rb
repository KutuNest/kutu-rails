require 'twilio-ruby'

class Notification < ApplicationRecord
  SmsSender = "+601117223008"
  TitlePrefix = "PlayKutu: "

  belongs_to :account_transaction, class_name: 'Transaction', required: false, foreign_key: 'transaction_id'
  belongs_to :account, required: false

  Statuses = {new: 'N', delivered: 'D', error: 'E'}

  Events = {
    disputed: 'TDP',
    failed: 'TFL',
    sender_confirmed: 'TSC',
    receiver_confirmed: 'TRC',
    limit_changed: 'MLC',
    has_finished: 'AHF'
  }

  #validates :notification_type, presence: true, inclusion: {in: Types.values}
  validates :status, presence: true, inclusion: {in: Statuses.values}
  validates :notification_event, presence: true, inclusion: {in: Events.values}
  #validates :body, presence: true

  before_validation :set_status

  after_create :deliver_email
  #after_create :deliver_sms

  def deliver_sms
    if Rails.env.production?
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: Notification::SmsSender,
        to: self.receiver_mobile_number,
        body: self.short_body
      )
    else
      true
    end
  end

  def deliver_email
    if self.receiver_email.present?
      evt = Notification::Events.find{|e| e.last == self.notification_event }.first
      email = self.receiver_email
      trx = self.account_transaction
      e = AppMailer.send(evt, trx, email)
      e.deliver_now
    end
  end

  def set_status
    self.status = Statuses[:new]
  end

  class << self
    def money_sent(trx)
      n = Notification.new
      n.account = eater
      n.title = "#{Notification::TitlePrefix} #{trx.feeder.member.username} just sent you money!"
      n.body  = "#{trx.feeder.member.full_name} (#{trx.feeder.member.username}) sent you amount of #{trx.value}"
      n.status = Statuses[:n]
    end
  end

end
