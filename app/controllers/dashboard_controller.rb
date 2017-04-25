class DashboardController < ApplicationController
  before_action :authenticate_member!

  def index
    if current_member.super_admin?
      @current_account = nil
      @groupements     = Groupement.includes(:pools => :accounts).all
      @members         = Member.all
    else 
      @groupements = [current_member.groupement].compact if current_member.group_admin?
      if @current_account.present?
        @transaction_history  = @current_account.transaction_history
        @current_transactions = @current_account.pending_transactions
        @current_transaction  = @current_transactions.pop
      end
    end
  end

  def members
    if current_member.super_admin?
      @members = Member.all
    elsif current_member.group_admin?
      @members = current_member.groupement.members rescue []
    end
  end

  def groups
    if current_member.super_admin?
      @groupements = Groupement.includes(:pools).all
    elsif current_member.group_admin?
      @groupements = [current_member.groupement].compact
    end
  end

  def setting
    @member = current_member
  end

end
