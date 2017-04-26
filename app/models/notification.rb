require 'twilio-ruby'

class Notification < ApplicationRecord
  SmsSender = "+601117223008"
  TitlePrefix = "PlayKutu: "

  belongs_to :account_transaction, class_name: 'Transaction', required: false, foreign_key: 'transaction_id'
  belongs_to :account, required: false
  belongs_to :member, required: false

  Statuses = {new: 'N', delivered: 'D', error: 'E'}

  Events = {
    disputed: 'TDP',
    failed: 'TFL',
    resolved: 'TRV',
    new_transaction: 'TNW',
    sender_confirmed: 'TSC',
    receiver_confirmed: 'TRC',
    limit_changed: 'MLC',
    has_finished: 'AHF',
    welcome_sms: 'MWS'
  }

  validates :status, presence: true, inclusion: {in: Statuses.values}
  validates :notification_event, presence: true, inclusion: {in: Events.values}

  before_validation :set_status

  after_create :deliver_email
  after_create :deliver_sms

  def deliver_sms
    if Rails.env.production? and sms_sending_allowed?

      counter_part = find_counter_part
      text_body = case Notification::Events.find{|e| e.last == self.notification_event }.first
        when :disputed then "Your PlayKutu transaction with #{counter_part.name} is being disputed. Go to PlayKutu.com"
        when :failed then "Your PlayKutu transaction with #{counter_part.name} is failed. Go to PlayKutu.com"
        when :resolved then "Your PlayKutu transaction dispute with #{counter_part.name} has been resolved. Go to PlayKutu.com"
        when :new_transaction then "Your PlayKutu transaction with #{counter_part.name} is now available. Go to PlayKutu.com"
        when :sender_confirmed then "Your PlayKutu transaction with #{counter_part.name} has been confirmed by sender. Go to PlayKutu.com"
        when :receiver_confirmed then "Your PlayKutu transaction with #{counter_part.name} has been confirmed by receiver. Go to PlayKutu.com"
        when :limit_changed then "Your PlayKutu #{self.account.member.username} accounts limit has been increased. Go to PlayKutu.com"
        when :has_finished then "Your PlayKutu account #{self.account.name} has finished send/receive. Go to PlayKutu.com"
        when :welcome_sms then "Welcome to playkutu.com, #{self.member.try(:email)}. Please check your email inbox for account confirmation."
      end

      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: Notification::SmsSender,
        to: self.receiver_mobile_number,
        body: text_body)
    else
      false
    end
  end

  def deliver_email
    if Rails.env.production? and email_sending_allowed?
      evt = Notification::Events.find{|e| e.last == self.notification_event }.first
      email = self.receiver_email
      trx = self.account_transaction
      e = AppMailer.send(evt, trx, email)
      e.deliver_now
    end
  end

  def email_sending_allowed?
    self.receiver_email.present? and (self.account.present? and self.account.member.email_notification == true) and self.notification_event != Events[:welcome_sms]
  end

  def sms_sending_allowed?
    self.receiver_mobile_number.present? and (self.account.present? and self.account.member.sms_notification == true)
  end

private

  def find_counter_part
    account_transaction.eater == account ? account_transaction.feeder : account_transaction.eater
  end  

  def set_status
    self.status = Statuses[:new]
  end

end
