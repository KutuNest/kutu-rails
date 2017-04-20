class AccountController < ApplicationController
  before_action :authenticate_member!

  def add
    if !current_member.super_admin? and current_member.groupement.accounts.size.zero?
      redirect_to dashboard_path, notice: "Sorry group and pool setup not finished yet. Please contact admin.."
    else
      account = current_member.generate_new_account
      if account
        redirect_to dashboard_path, notice: "New account: #{account.name} has been successfully created"
      else
        redirect_to dashboard_path, notice: 'Unable to create new account. Please contact admin'
      end
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

  def kick_out
    account = Account.where(id: params[:id]).first
    if account.present?
      account.kick_out!
      redirect_to :back, notice: "Account #{account.name} has been kicked out"
    else
      redirect_to :back, notice: 'An error occured on kicking account'
    end
  end

end
