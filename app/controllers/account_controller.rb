class AccountController < ApplicationController
  def add
    pool = Groupement.first.pools.first
    account = current_member.generate_new_account
    if account
      redirect_to dashboard_path, notice: "New account: #{account.name} has been successfully created"
    else
      redirect_to dashboard_path, notice: 'Unable to create new account. Please contact admin'
    end
  end

  def change_pool_order
  	account = Account.where(id: params[:id]).first
  	if account.present? and account.change_pool_order!(params[:pool_order])
  		redirect_to :back, notice: 'Account order has been updated'
  	else
  		redirect_to :back, notice: 'An error occured on changing pool order'
  	end
  end

  def switch
    account = Account.where(id: params[:id], member_id: current_member.id).first
    session[:current_account] = account.id
    redirect_to dashboard_path, notice: "Account switched to #{account.name}"
  end
end
