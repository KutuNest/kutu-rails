module Members
  module Generator
    extend ActiveSupport::Concern
    
    included do
      before_validation :generate_referral_code
    end

    def generate_new_account
      if account_quota_available?
        pool = self.groupement.initial_pool
        a = self.accounts.new
        a.auto_populate(pool)
        a.save
      end
    end

    def create_account_allowed?
      self.accounts.count < self.accounts_limit
    end

    def generate_referral_code
      ref_code = SecureRandom.hex(3)
      ref_code = ref_code + rand(10) if Member.where(referral_code: ref_code).any?
      self.referral_code = ref_code
    end
  end
end