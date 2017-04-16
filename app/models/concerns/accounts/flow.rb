module Accounts
  module Flow
    extend ActiveSupport::Concern

    included do
      after_create :create_new_transaction
    end

    def proceed_last_transaction!
      self.bottomize_pool_order!
      
      if self.has_finished_group?
        self.retire!
      elsif self.has_finished_pool?
        self.enter_next_pool!
      elsif self.has_been_sending?
        self.do_nothing
      end      
    end

    def do_nothing
      true
    end

    def bottomize_pool_order!
      self.pool_order = self.pool.accounts.maximum(:pool_order) + 1
    end

    def has_been_sending?
      if self.super_user?
        true
      else
        self.pool.p_transactions.where(feeder_id: self.id).count >= 1
      end
    end

    def has_been_receiving?
      self.pool.p_transactions.where(eater_id: self.id).count == self.pool.feeders_count
    end

    def has_successfully_sent?
      if self.super_user?
        true
      else
        self.pool.p_transactions.success.where(feeder_id: self.id).count >= 1
      end
    end

    def has_successfully_received?
      self.pool.p_transactions.success.where(eater_id: self.id).count == self.pool.feeders_count
    end

    def has_finished_pool?
      has_successfully_sent? and has_successfully_received?
    end

    def has_finished_group?
      has_finished_pool? and self.pool.last_group_pool?
    end

    def enter_next_pool!
      self.pool = self.pool.next_pool
      self.number_associations_left = self.pool.feeders_count
      self.save
      if !self.super_user?
        create_new_transaction
      end
    end

    def retire!
      self.has_finished = true
      self.number_associations_left = 0
      self.save
      set_new_accounts_limit
    end

    def set_new_accounts_limit
      m = self.member
      m.accounts_limit = m.accounts_limit + 8
      m.save
    end

    def create_new_transaction
      if !self.super_user? and self.number_associations_left > 0
        t = self.a_transactions.new
        t.member = self.member
        t.timeout = self.pool.timeout.to_i.seconds
        t.pool = self.pool
        t.value = self.pool.amount

        #TODO: eater from pool, that hasn't been sent limit from pool
        t.feeder = self
        t.eater = self.pool.first_target(self)
        if t.save
          t_eater = t.eater
          t_eater.number_associations_left = t_eater.number_associations_left.to_i - 1
          t_eater.save
        end
      end
    end

  end
end