module Accounts
  module Populator
    extend ActiveSupport::Concern

    included do
      before_validation :set_defaults
    end

    def auto_populate(pool)
      self.pool = pool
      self.groupement = pool.groupement if pool.present?
      generate_account_id
    end

  private
    def set_defaults
      if self.new_record?
        self.kicked_out = false

        self.super_user = false if self.super_user.blank?
        self.action_available = false if self.action_available.blank?
        self.number_associations_left = Account::DefaultNumberAssociations if self.number_associations_left.blank?
      end
    end

    def generate_account_id
      accounts = self.member.accounts.map{|a| a.name.to_s.split("_").last.to_i }.sort
      if accounts.any?
        self.name = self.member.username + "_#{accounts.last + 1}"
      else
        self.name = self.member.username + "_#{0}"
      end
    end

  end
end