module Members
  module Translator
    extend ActiveSupport::Concern
    
    def full_name
      "#{self.first_name} #{self.last_name}"
    end

    def super_admin?
      self.role == Member::Roles[:super_admin]
    end

    def group_admin?
      self.role == Member::Roles[:group_admin]
    end

    def regular_member?
      self.role == Member::Roles[:regular_member]
    end

    def role_name
      Member::Roles.find{|a| a.last == self.role }.first.to_s
    end

    def bank_info_completed?
      self.account_holder_name.present? and self.account_number.present? and self.bank_id.present?
    end
      
  end
end