class TransactionController < ApplicationController
  before_action :authenticate_member!

  def list
    @transactions = current_member.transactions
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

  def edit
  end

  def update
  end

  def confirm
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
