class DashboardController < ApplicationController
  def index
    if current_member.super_admin?
      @current_account = nil
      @groupements = Groupement.includes(:pools => :accounts).all
      @members = Member.all
    else 
      @groupements = [current_member.groupement].compact if current_member.group_admin?

      if @current_account.present?
        @transaction_history = @current_account.a_transactions
        @current_transaction = @transaction_history.where(feeder_id: @current_account.id).last
        @transaction_history = @transaction_history.to_a - [@current_transaction]
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
