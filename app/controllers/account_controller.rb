class AccountController < ApplicationController
  def add
    pool = Pool.first
    account = current_member.generate_new_account(pool)
    if account
      redirect_to dashboard_path, notice: "New account: #{account.name} has been successfully created"
    else
      redirect_to dashboard_path, notice: 'Unable to create new account. Please contact admin'
    end
  end
end
