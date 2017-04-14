module Accounts
  module Flow
    extend ActiveSupport::Concern

    included do
      after_create :create_transaction
    end

    def proceed_last_transaction!
      if self.has_finished_pool?
        self.enter_next_pool!
      elsif self.has_finished_group?
        self.kick_his_ass!
      else
        self.create_pool_transaction!
      end      
    end

    def has_finished_receive?
      self.a_transactions.where(pool_id: self.pool_id, admin_confirmed: true, receiver_confirmed: true, sender_confirmed: true, eater_id: self.id).count > 0
    end

    def has_finished_pool?
      (self.pool.feeders_count  == self.a_transactions.where(pool_id: self.pool_id, admin_confirmed: true, receiver_confirmed: true, sender_confirmed: true, feeder_id: self.id).count) and 
        self.a_transactions.where(pool_id: self.pool.id, admin_confirmed: true, receiver_confirmed: true, sender_confirmed: true, eater_id: self.id).any?
    end

    def has_finished_group?
      has_finished_pool? and self.pool.last_group_pool?
    end

    def enter_new_pool!
      self.pool = self.groupement.default.first_pool
      self.number_associations_left -= 1
      create_transaction
      self.save      
    end

    def enter_next_pool!
      next_pool = self.pool.next_pool
      self.pool = next_pool
      self.number_associations_left -= 1
      create_transaction
      self.save
    end

    def create_pool_transactions!
      self.number_associations_left -= 1
      create_transaction
      self.save
    end

    def kick_his_ass!
      self.has_finished = true
      self.number_associations_left = 0
      self.save
    end

    def create_transaction
      unless self.super_user?
        t = self.a_transactions.new
        t.member = self.member
        t.timeout = self.pool.timeout.to_i.seconds
        t.pool = self.pool
        t.value = self.pool.amount

        #TODO: eater from pool, that hasn't been sent limit from pool
        t.feeder = self
        t.eater = self.pool.first_target(self)
        t.save
        pp t
        pp t.errors
      end
    end

  end
end