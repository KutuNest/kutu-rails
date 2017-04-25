module Notifications
  module Texting
    extend ActiveSupport::Concern

    def money_sent(trx)
      n = Notification.new
      n.account = eater
      n.title = "#{Notification::TitlePrefix} #{trx.feeder.member.username} just sent you money!"
      n.body  = "#{trx.feeder.member.full_name} (#{trx.feeder.member.username}) sent you amount of #{trx.value}"
      n.status = Statuses[:n]
    end    

  end
end