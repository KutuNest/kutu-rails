class PoolController < ApplicationController
  before_action :authenticate_member!

  def edit
    if current_member.super_admin?
      @pool = Pool.where(id: params[:id]).first
    elsif current_member.group_admin?
      @pool = current_member.groupement.pools.where(id: params[:id]).first
    end
  end

  def add
    if current_member.super_admin? or current_member.group_admin?
      @pool = Pool.new
    end
  end

  def save
    if current_member.super_admin? or current_member.group_admin?
      @pool = Pool.new(pool_params)
      @pool.groupement = current_member.groupement if current_member.group_admin?
      if @pool.save
        redirect_to :back, notice: "Pool #{@pool.title} has been saved"
      else
        render action: 'add'
      end
    end
  end

  def update
    if current_member.super_admin? or current_member.group_admin?
      @pool = Pool.where(id: params[:id]).first

      update_pool_params = pool_params
      if current_member.group_admin?
        update_pool_params.delete(:groupement_id)
        @pool.groupement   = current_member.groupement 
      end

      if @pool.update(update_pool_params)
        redirect_to :back, notice: "Pool #{@pool.title} has been saved"
      else
        render action: 'edit'
      end    
    end
  end 

  private
  def pool_params
    params.require(:pool).permit(:groupement_id, :title, :feeders_count, :amount, :position, :timeout)
  end

end
