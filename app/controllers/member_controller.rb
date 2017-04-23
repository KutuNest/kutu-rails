class MemberController < ApplicationController
  before_action :authenticate_member!

  def edit
    if current_member.super_admin?
      @member = Member.where(id: params[:id]).first
    elsif current_member.group_admin?
      @member = current_member.groupement.members.where(id: params[:id]).first
    elsif current_member.regular_member?
      @member = current_member
    end
  end

  def update
    member_params = set_member_params
    if current_member.super_admin?
      @member = Member.where(id: params[:id]).first
    elsif current_member.group_admin?
      @member = current_member.groupement.members.where(id: params[:id]).first
    elsif current_member.regular_member?
      @member = current_member
    end

    if @member.present? and @member.update(member_params)
      redirect_to dashboard_path(@member), notice: 'Member changes has been saved'
    else
      render action: 'edit'
    end
  end

  def complete
    @member = current_member
  end

  def lock
    if current_member.super_admin?
      @member = Member.where(id: params[:id]).first
    elsif current_member.group_admin?
      @member = current_member.groupement.members.where(id: params[:id]).first
    end

    if @member.present?
      @member.unlock_access! if @member.access_locked?
      @member.lock_access! unless @member.access_locked?

      redirect_to members_path, notice: 'Member lock setting has been changed'
    else
      redirect_to members_path, notice: 'Unable to change member lock setting'
    end
  end

  def show
    if current_member.super_admin?
      @member = Member.where(id: params[:id]).first
    elsif current_member.group_admin?
      @member = current_member.groupement.members.where(id: params[:id]).first
    end
  end

  def increase_accounts_limit
    if current_member.super_admin?
      @member = Member.where(id: params[:id]).first
    elsif current_member.group_admin?
      @member = current_member.groupement.members.where(id: params[:id]).first
    end

    if @member.present? and @member.accounts_limit < params[:accounts_limit].to_i
      @member.accounts_limit = params[:accounts_limit].to_i
      @member.save
      redirect_to members_path, notice: "Account limit for #{@member.username} is now #{@member.accounts_limit}"
    else
      redirect_to members_path, notice: "Failed to increase account limit. Probably must greater than previous limit."
    end
  end

  def add_group
    if current_member.super_admin?
      @group = Groupement.new
    end
  end

  def save_group
    if current_member.super_admin?
      group_params = set_group_params
      @groupement = Groupement.new(group_params)
      if @groupement.save
        redirect_to groups_path, notice: "Group #{@groupement.title} has been saved"
      else
        redirect_to :back, notice: "Groupement error: #{@groupement.errors.to_a.first}"
      end
    end
  end

  def edit_group
    if current_member.super_admin?
      @group = Groupement.find(params[:id])
    elsif @current_member.group_admin?
      @group = current_member.groupement
    end
  end

  def update_group
    if current_member.super_admin?
      @groupement = Groupement.find(params[:id])

      group_params = set_group_params
      if @groupement.update(group_params)
        redirect_to groups_path, notice: "Group #{@groupement.title} has been saved"
      else
        redirect_to :back, notice: "Error: #{@groupement.errors.to_a.first}"
      end
    end
  end

  def add_super_user
    if current_member.super_admin? or current_member.group_admin?
      @member = Member.new
    end
  end

  def save_super_user
    if current_member.super_admin? or current_member.group_admin?
      member_params = set_member_params.merge(referrer_code: params[:member][:referrer_code])
      @member = Member.new(member_params)

      if current_member.super_admin?
        @member.groupement_id = params[:member][:groupement_id]
      elsif current_member.group_admin?
        @member.groupement = current_member.groupement
      end

      if @member.save
        @member.generate_new_account(true)
        redirect_to dashboard_path, notice: "Member #{@member.try(:username)} with super user has been saved"
      else
        render action: 'add_super_user'
      end
    end
  end

  def add_admin
    if current_member.super_admin?
      @member = Member.new
    end
  end

  def save_admin
    if current_member.super_admin?
      member_params = set_member_params.merge(groupement_id: params[:member][:groupement_id], referrer_code: params[:member][:referrer_code])
      @member = Member.new(member_params)
      
      if params[:role] == 's'
        @member.role = Member::Roles[:super_admin]
        @member.groupement = nil
      elsif params[:role] == 'g'
        @member.role = Member::Roles[:super_admin]
      end

      if @member.save
        redirect_to dashboard_path, notice: "Member #{@member.try(:username)} as an admin has been saved"
      else
        render action: 'add_admin'
      end  
    end
  end

private
  def set_member_params
    params.require(:member).permit(:email, :username, :password, :password_confirmation, :first_name, :last_name, :phone_number, :bank_id, :account_number, :account_holder_name)
  end

  def set_group_params
    params.require(:groupement).permit(:activated_on_create, :initial_accounts, :maximum_accounts, :accounts_added_on_success, :title)
  end

end
