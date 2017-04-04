class MemberController < ApplicationController
  def edit
    @member = Member.where(id: params[:id]).first
  end

  def update
    member_params = params.require(:member).permit(:first_name, :last_name, :phone_number, :bank_id, :account_number, :account_holder_name)
    @member = Member.where(id: params[:id]).first
    if @member.update(member_params)
      redirect_to edit_member_path(@member), notice: 'Member changes has been saved'
    else
      render action: 'edit'
    end
  end

end
