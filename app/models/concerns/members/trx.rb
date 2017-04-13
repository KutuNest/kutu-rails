module Members
  module Trx
    extend ActiveSupport::Concern

    def send_money(account_feeder, account_eater)
      t = Transaction.where(eater_id: account_eater.id, feeder_id: self.account_feeder.id).first
      if t.present?
        t.sender_ack = true
        t.save
      end
    end

    def current_transaction(account=nil)
      account = self.accounts.first if account.nil?
      if account and account.member_id == self.id
        Transaction.where(feeder_id: account.id, admin_confirmed: true).first
      end
    end

    def transaction_history(account=nil)
      account = self.accounts.first if account.nil?
      if account and account.member_id == self.id
        Transaction.where(feeder_id: account.id, admin_confirmed: false)
      end
    end

  end
end