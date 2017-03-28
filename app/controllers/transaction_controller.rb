class TransactionController < ApplicationController
  def list
    @transactions = current_member.transactions
  end

  def show
    if current_member.regular_member?
      #TODO:
    else
      @transaction = Transaction.find(params[:id])
    end
  end

  def edit
  end

  def update
  end

  def pay
  end

  def confirm
  end

  def store
  end

  def receipt
    @receipt = 
  end

end
