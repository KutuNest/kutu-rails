class PoolController < ApplicationController
  def edit
    @pool = Pool.find(params[:id])
  end

  def add
    @pool = Pool.new
  end

  def save
    @pool = Pool.new(pool_params)
    if @pool.save
      redirect_to :back, notice: "Pool #{@pool.title} has been saved"
    else
      render action: 'add'
    end    
  end

  def update
    @pool = Pool.find(params[:id])
    if @pool.update(pool_params)
      redirect_to :back, notice: "Pool #{@pool.title} has been saved"
    else
      render action: 'edit'
    end    
  end 

  private
  def pool_params
    params.require(:pool).permit(:groupement_id, :title, :feeders_count, :amount, :position, :timeout)
  end

end
