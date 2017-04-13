module Accounts
  module Populator
    extend ActiveSupport::Concern

    included do
      before_validation :set_defaults
    end

    def auto_populate(pool)
      self.pool = pool
      self.pool_order = self.pool.accounts.maximum(:pool_order) + 1
      self.groupement = pool.groupement if pool.present?
      self.name = generate_account_id
      self.arrival_date = Date.today
    end

  private
    def set_defaults
      if self.new_record?
        self.kicked_out = false
        self.super_user = false if self.super_user.blank?
        self.has_finished = false if self.has_finished.blank?
        self.number_associations_left = self.pool.feeders_count - 1 if self.number_associations_left.blank?

        if self.action_available.blank?
          self.action_available = false if self.super_user? 
          self.action_available = true
        end

      end
    end

    def generate_account_id
      accounts = self.member.accounts.map{|a| a.name.to_s.split("_").last.to_i }.sort
      if accounts.any?
        account_name = self.member.username + "_#{accounts.last + 1}"
      else
        account_name = self.member.username + "_#{0}"
      end

      account_name
    end

  end
end