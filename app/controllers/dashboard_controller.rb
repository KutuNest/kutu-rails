class DashboardController < ApplicationController
  def index
    @current_account = nil

    if current_member.super_admin?
      @groupements = Groupement.includes(:pools => :accounts).all
      @members = Member.all
    elsif current_member.group_admin?
      @groupements = [current_member.groupement]
    elsif current_member.regular_member?
      @current_transaction = current_member.current_transaction
      @transaction_history = current_member.transaction_history      
      @current_transaction = current_member.transactions.first if @current_transaction.nil?

      if params[:acc].present?
        @current_account = current_member.accounts.where(name: params[:acc]).first
      else
        @current_account = current_member.accounts.first
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
      @members = current_member.groupement.pools.map {|p| p.members }.compact
    end
  end  

  def admin
    @groupement = current_member.groupement
  end

  def groups
    @groupements = Groupement.includes(:pools).all
  end

  def add_group
    @group = Groupement.new
  end

  def save_group
    group_params = params.require(:group).permit(:activated_on_create, :initial_accounts, :maximum_accounts, :accounts_added_on_success, :title)
    @groupement = Groupement.new(group_params)
    if @groupement.save
      redirect_to :back, notice: "Group #{@groupement.title} has been saved"
    else
      redirect_to :back, notice: "Error: #{@groupement.errors.to_a.first}"
    end
  end

  def add_pool
    @pool = Pool.new
  end

  def save_pool
    pool_params = params.require(:pool).permit(:title, :amount, :position, :timeout)
    @pool = Pool.new(pool_params)
    if @pool.save
      redirect_to :back, notice: "Pool #{@pool.title} has been saved"
    else
      redirect_to :back, notice: "Error: #{@pool.errors.to_a.first}"
    end    
  end

  def add_super_user
    @member = Member.new
  end

  def save_super_user
    member_params = params.require(:member).permit(:title, :amount, :position, :feeders_count, :timeout)
    @member = Member.new(member_params)
    @member.super_user = true
    if @member.save
      redirect_to :back, notice: "Super user #{@member.title} has been saved"
    else
      redirect_to :back, notice: "Error: #{@member.errors.to_a.first}"
    end        
  end


end
