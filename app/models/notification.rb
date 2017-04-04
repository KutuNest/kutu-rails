require 'twilio-ruby'

class Notification < ApplicationRecord
  SmsSender = "+601117223008"
  TitlePrefix = "PlayKutu: "

  belongs_to :account_transaction, class_name: 'Transaction'
  belongs_to :account

  Types    = {sms: 'S', email: 'E'}
  Statuses = {new: 'N', delivered: 'D', error: 'E'}

  validates :notification_type, presence: true, inclusion: {in: Types.values}
  validates :status, presence: true, inclusion: {in: Statuses.values}
  validates :body, presence: true

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
      AppMailer.notification(self).deliver_now
    end
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
