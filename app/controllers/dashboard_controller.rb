class DashboardController < ApplicationController
  def index
    if current_member.super_admin?
      @groupements = Groupement.includes(:pools => :accounts).all
      @members = Member.all
    elsif current_member.group_admin?
      @groupements = [current_member.groupement]
    elsif current_member.regular_member?
      @current_transaction = current_member.current_transaction
      @transaction_history = current_member.transaction_history      
      @current_transaction = current_member.transactions.first if @current_transaction.nil?
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
      @members = current_member.groupement.pools.map {|p| p.members }.compact
    end
  end  

  def admin
    @groupement = current_member.groupement
  end

  def groups
    @groupements = Groupement.includes(:pools).all
  end

end
