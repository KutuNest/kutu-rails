class DashboardController < ApplicationController
  def index
    if current_member.super_admin?
      @current_account = nil
      @groupements = Groupement.includes(:pools => :accounts).all
      @members = Member.all
    elsif current_member.group_admin?
      @groupements = [current_member.groupement].compact
      if @current_account.present?
        transactions = @current_account.a_transactions.to_a
        @current_transaction = transactions.pop
        @transaction_history = transactions
      end      
    elsif current_member.regular_member?
      if @current_account.present?
        transactions = @current_account.a_transactions.to_a
        @current_transaction = transactions.pop
        @transaction_history = transactions
      end
    end
  end

  def member
    @current_transaction = current_member.current_transaction
    @transaction_history = current_member.transaction_history
  end

  def members
    if current_member.super_admin?
      @members = Member.all
    elsif current_member.group_admin?
      @members = current_member.groupement.members
    end
  end  

  def admin
    @groupement = current_member.groupement
  end

  def groups
    @groupements = Groupement.includes(:pools).all
  end

  def setting
    @member = current_member
  end

end
