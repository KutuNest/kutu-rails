class TransactionController < ApplicationController
  before_action :authenticate_member!

  def list
    if current_member.super_admin?
      @transactions = Transaction.order(updated_at: :desc)
    elsif current_member.group_admin?
      @transactions = Transaction.where(pool_id: current_member.groupement.pools.map(&:id)).order(updated_at: :desc) rescue []
    end
  end

  def disputes
    if current_member.super_admin?
      @transactions = Transaction.disputed
    elsif current_member.group_admin?
      @transactions = Transaction.disputed.where(pool_id: current_member.groupement.pools.map(&:id)) rescue []
    end    
  end

  def dispute
    @transaction = Transaction.where(id: params[:id]).first

    if @transaction.present? and (@transaction.eater.member == current_member or @transaction.feeder.member == current_member)
      @transaction.dispute!
      @transaction.save
      @transaction.notify_disputed
      redirect_to transaction_path(@transaction), notice: 'Transaction has been disputed'
    else
      redirect_to transaction_path(@transaction), notice: "Unable to dispute transaction: #{@transaction.errors.to_a.first}"
    end
  end

  def show
    if current_member.regular_member?
      @transaction = Transaction.by_member(current_member).where(id: params[:id]).first
    else
      @transaction = Transaction.where(id: params[:id]).first
    end
  end

  def settle
    if current_member.regular_member?
      @transaction = Transaction.by_member(current_member).where(id: params[:id]).first
    else
      @transaction = Transaction.where(id: params[:id]).first
    end

    if @transaction.disputed?
      redirect_to transaction_path(@transaction), notice: "Transaction is currently under dispute"
    else
      @transaction.receiver_confirmed = true
      @transaction.admin_confirmed    = true

      if @transaction.save
        @transaction.notify_receiver_confirmed
        notice =  "You've successfully confirmed settlement of the transfer"
      else
        notice = "Unable to confirm settlement: #{@transaction.errors.to_a.first}"
      end
      redirect_to transaction_path(@transaction), notice: notice
    end
  end

  def confirm
    unless current_member.regular_member?
      @transaction = Transaction.where(id: params[:id]).first
      if @transaction.present?
        @transaction.admin_confirmed    = true
        @transaction.sender_confirmed   = true
        @transaction.receiver_confirmed = true
        @transaction.completed_date     = Date.today
        @transaction.failed   = false
        @transaction.disputed = false
        if @transaction.save
          @transaction.notify_resolved
          redirect_to transaction_path(@transaction), notice: 'Transaction has been confirmed'
        else
          redirect_to transaction_path(@transaction), notice: "Unable to confirm transaction: #{@transaction.errors.to_a.first}"
        end
      else
        redirect_to transaction_path(@transaction), notice: "Transaction not found or not authorized"
      end
    end
  end

  def reject
    unless current_member.regular_member?
      @transaction = Transaction.where(id: params[:id]).first
      if @transaction.present?
        @transaction.admin_confirmed = false
        @transaction.disputed        = false
        @transaction.failed          = true

        if @transaction.save
          eater = @transaction.eater
          eater.number_associations_left = eater.number_associations_left + 1
          eater.save

          @transaction.notify_failed
          redirect_to transaction_path(@transaction), notice: 'Transaction has been rejected'
        else
          redirect_to transaction_path(@transaction), notice: "Unable to confirm transaction: #{@transaction.errors.to_a.first}"
        end
      else
        redirect_to transaction_path(@transaction), notice: "Transaction not found or not authorized"
      end
    end
  end

  def send_money
    @transaction = Transaction.by_member(current_member).where(id: params[:id]).first
  end

  def upload_receipt
    if current_member.regular_member? or current_member.group_admin?
      @transaction = Transaction.by_member(current_member).where(id: params[:id]).first 
      
      @transaction.sender_receipt = params[:receipt]
      @transaction.sender_confirmed = true

      if @transaction.save
        @transaction.notify_sender_confirmed
        redirect_to transaction_path(@transaction.id), notice: "You have confirmed sending money to receiver"
      else
        redirect_to transaction_path(@transaction.id), notice: "Unable to save receipt: #{@transaction.errors.to_a.first}"
      end
    end
  end

  def receipt
    if current_member.regular_member?
      @transaction = Transaction.by_member(current_member).where(id: params[:id]).first
    else
      @transaction = Transaction.where(id: params[:id]).first
    end
    send_file File.open(@transaction.sender_receipt.file.file) if @transaction.present? and @transaction.sender_receipt.file.present?
  end

end
