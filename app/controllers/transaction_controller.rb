class TransactionController < ApplicationController
  before_action :authenticate_member!

  def list
    @transactions = Transaction.all
  end

  def disputes
    @transactions = Transaction.all
  end

  def dispute
  end

  def show
    if current_member.regular_member?
      account_ids = current_member.accounts.map(&:id)
      @transaction = Transaction.where(id: account_ids).where(id: params[:id]).first
    else
      @transaction = Transaction.where(id: params[:id]).first
    end
    #TODO: 
    @transaction = Transaction.where(id: params[:id]).first
  end

  def settle
    #TODO: limit member
    @transaction = Transaction.where(id: params[:id]).first
    @transaction.receiver_ack = true
    notice = if @transaction.save
      "You've successfully confirmed settlement of the transfer"
    else
      "Unable to confirm settlement"
    end
    redirect_to transaction_path(@transaction), notice: notice
  end

  def confirm
    @transaction = Transaction.where(id: params[:id]).first
    if @transaction
      @transaction.admin_confirmed = true
      @transaction.completed_date = Date.today
      @transaction.failed = false
      if @transaction.save
        redirect_to :back, notice: 'Transaction has been confirmed'
      else
        redirect_to :back, notice: 'Unable to perform action'
      end
    else
      redirect_to :back, notice: 'Unable to perform action'
    end
  end

  def reject
    @transaction = Transaction.where(id: params[:id]).first
    if @transaction
      @transaction.admin_confirmed = false
      @transaction.failed = false
      if @transaction.save
        redirect_to :back, notice: 'Transaction has been rejected'
      else
        redirect_to :back, notice: 'Unable to perform action'
      end
    else
      redirect_to :back, notice: 'Unable to perform action'
    end    
  end

  def send_money
    @transaction = Transaction.where(id: params[:id]).first
  end

  def upload_receipt
    @transaction = Transaction.where(id: params[:id]).first
    @transaction.sender_receipt = params[:receipt]
    if @transaction.save
      redirect_to transaction_path(@transaction.id), notice: 'Receipt has already been saved'
    else
      redirect_to transaction_path(@transaction.id), notice: @transaction.errors.to_a.first
    end
  end

  def receipt
    @transaction = Transaction.where(id: params[:id]).first
    send_file @transaction.sender_receipt.url
  end

end
