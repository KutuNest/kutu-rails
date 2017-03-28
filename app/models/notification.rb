require 'twilio-ruby'

class Notification < ApplicationRecord
  SmsSender = "+17088882081"

  belongs_to :account_transaction, class_name: 'Transaction'
  belongs_to :account

  Types    = {sms: 'S', email: 'E'}
  Statuses = {new: 'N', delivered: 'D', error: 'E'}

  validates :notification_type, presence: true, inclusion: {in: Types.values}
  validates :status, presence: true, inclusion: {in: Statuses.values}
  validates :body, presence: true

  def deliver_sms
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: Notification::SmsSender,
      to: self.receiver_mobile_number,
      body: self.short_body
    )
  end

  def deliver_email
    if self.receiver_email.present?
      AppMailer.notification(self).deliver_now
    end
  end

end
