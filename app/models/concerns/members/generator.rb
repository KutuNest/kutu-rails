module Members
  module Generator
    extend ActiveSupport::Concern
    
    included do
      before_validation :generate_referral_code
    end

    def generate_new_account
      pool = Pool.first
      a = self.accounts.new
      a.auto_populate(pool)
      a.valid?
      if a.save
        a
      else
        false
      end
    end

    def generate_referral_code
      ref_code = SecureRandom.hex(3)
      ref_code = ref_code + rand(10) if Member.where(referral_code: ref_code).any?
      self.referral_code = ref_code
    end
  end
end