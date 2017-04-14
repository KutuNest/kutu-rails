class MemberController < ApplicationController
  def edit
    @member = Member.where(id: params[:id]).first
  end

  def complete
    @member = current_member
  end

  def update
    member_params = params.require(:member).permit(:first_name, :last_name, :phone_number, :bank_id, :account_number, :account_holder_name)
    @member = Member.where(id: params[:id]).first
    if @member.present? and @member.update(member_params)
      redirect_to edit_member_path(@member), notice: 'Member changes has been saved'
    else
      render action: 'edit'
    end
  end

  def lock
    @member = Member.where(id: params[:id]).first

    if @member
      @member.unlock_access! if @member.access_locked?
      @member.lock_access! unless @member.access_locked?

      redirect_to :back, notice: 'Member lock setting has been changed'
    else
      redirect_to :back, notice: 'Unable to change member lock setting'
    end
  end

  def show
    @member = Member.where(id: params[:id]).first
  end

  def increase_accounts_limit
    @member = Member.where(id: params[:id]).first
    if @member
      @member.accounts_limit = params[:accounts_limit]
      @member.save
      redirect_to :back, notice: "Account limit for #{@member.username} is now #{@member.accounts_limit}"
    else
      redirect_to :back, notice: "Failed to increase account limit"
    end
  end

  def add_group
    @group = Groupement.new
  end

  def save_group
    group_params = params.require(:groupement).permit(:activated_on_create, :initial_accounts, :maximum_accounts, :accounts_added_on_success, :title)
    @groupement = Groupement.new(group_params)
    if @groupement.save
      redirect_to groups_path, notice: "Group #{@groupement.title} has been saved"
    else
      redirect_to :back, notice: "Error: #{@groupement.errors.to_a.first}"
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
