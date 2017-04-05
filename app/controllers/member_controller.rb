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

end
