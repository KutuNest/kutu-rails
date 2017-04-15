module Members
  module Generator
    extend ActiveSupport::Concern
    
    included do
      before_validation :generate_referral_code
    end

    def generate_new_account(super_user=false)
      if can_add_account?
        pool = self.groupement.first_pool
        a = self.accounts.new
        a.auto_populate(pool)
        if super_user
          a.action_available = false
          a.super_user = true
        end
        if a.save
          a
        else
          false
        end
      end
    end

    def generate_referral_code
      if self.new_record?
        ref_code = SecureRandom.hex(3)
        ref_code = ref_code + rand(10) if Member.where(referral_code: ref_code).any?
        self.referral_code = ref_code
      end
    end
  end
end