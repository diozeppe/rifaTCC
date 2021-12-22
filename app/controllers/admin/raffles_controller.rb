class Admin::RafflesController < ApplicationController
	before_action :set_raffle, only: [:edit, :update, :show, :destroy]

	def index
	  @raffles = Raffle.page(params[:page])
	end

	def new
	  @raffle = Raffle.new
	end

	def edit
	  
	end

	def create
	  render plain: params[:raffle].inspect
	  @raffle = Raffle.new(raffle_params)
	  if @raffle.save
	  	flash[:sucess] = "Campanha criada com sucesso"
	  	redirect_to admin_raffle_path(@raffle)
	  else
	  	render 'new'
	  end
	end

	def update
	  if @raffle.update(raffle_params)
	  	flash[:sucess] = "Campanha atualizada com sucesso"
	  	redirect_to admin_raffle_path(@raffle)
	  else
	  	render 'edit'
	  end
	end

	def show
	  
	end

	def destroy
	  
	  @raffle.destroy
	  flash[:danger] = "Campanha deletada com sucesso"
	  redirect_to admin_raffles_path
	end

	private

	  def set_raffle
	  	@raffle = Raffle.find(params[:id])
	  end

	  def raffle_params
	  	params.require(:raffle).permit(:description)

	  end

end