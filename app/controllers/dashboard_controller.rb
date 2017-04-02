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

  def admin
    @groupement = current_member.groupement
  end

  def group
    @groupements = Groupement.includes([:pools, :members]).all
  end

  def add
    account = Account.new
    if current_member.regular_member?
      account.member = current_member

    else
      account.member = params[:member_id]
    end
    #TODO: more columns
    account.arrival_date = DateTime.now
    account.admin_account = false
    account.save
  end

end
