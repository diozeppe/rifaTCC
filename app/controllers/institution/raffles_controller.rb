class Institution::RafflesController < ApplicationController
	before_action :set_institution
	before_action :set_raffle, only: [:edit, :update, :show, :destroy]

	def index
	  authorize @institution, policy_class: RafflePolicy

	  @validation = validate_filters

	  if @validation.empty?
	  	@raffles = get_filters.page(params[:page])
	  else
	  	@raffles = @institution.raffles.page(params[:page])
	  end
	end

	def new
	  authorize @institution, policy_class: RafflePolicy
	  @raffle = Raffle.new
	end

	def edit
	  
	end

	def create
	  @raffle = Raffle.new(raffle_params)
	  @raffle.institution = @institution

	  authorize @raffle, policy_class: RafflePolicy

	  if @raffle.save

	    params[:images].each do |img|
	    	@raffle.images.attach(img[1])
	    end
	
	  	redirect_to :institution_raffles, :notice => "Rifa criada com sucesso"
	  else
		respond_to do |format|
		format.json {render :json => {:model => @raffle.class.name.downcase, :error => @raffle.errors.as_json}, :status => 422}
		format.html {render 'new'}
		end
	  end

	end

	def update
	  if @raffle.update(raffle_params)
	  	flash[:sucess] = "Usuario atualizado com sucesso"
	  	redirect_to raffles_show(@raffle)
	  else
	  	render 'edit'
	  end
	end

	def show
	  
	end

	def upload
		
	end

	def destroy
	  @raffle.destroy
	  flash[:danger] = "Rifa deletada com sucesso"
	  redirect_to raffles_path
	end

	private

	  def set_raffle
	  	@raffle = Raffle.find(params[:id])
	  end

	  def set_institution
	  	@institution = pundit_user
	  end

	  def raffle_params
	  	params.require(:raffle).permit(
        :title,
        :description,
        :prize,
        :prize_description,
        :category_id,
        :condition_id,
        :delivery_type_id,
        :unit_value,
        :tickets_number,
        :draw_date,
        images:[]
		)
	  end

	  def filter_pararms
	  	params.permit(
        :category_id,
        :condition_id,
        :raffle_status_id,
        :draw_date_initial,
        :draw_date_final,
        :unit_value_min,
        :unit_value_max 
        )
	  end

	  def validate_filters
	  	errors = {}

	  	if params.key?(:draw_date_initial) && !params[:draw_date_initial].empty?
	  		begin
	  			DateTime.strptime(params[:draw_date_initial], '%d/%m/%Y')
	  		rescue StandardError
	  			errors[:draw_date_initial] = "Data inválida"
	  		end
	  	end

	  	if params.key?(:draw_date_final) && !params[:draw_date_final].empty?
	  		begin
	  			DateTime.strptime(params[:draw_date_final], '%d/%m/%Y')
	  		rescue StandardError
	  			errors[:draw_date_final] = "Data inválida"
	  		end
	  	end

	  	errors
	  end

	  def get_filters
	  	result = @institution.raffles

	  	if params.key?(:category_id) && !params[:category_id].empty?
	  		result = result.where('category_id = ? ', filter_pararms[:category_id].to_f)
	  	end

	  	if params.key?(:condition_id) && !params[:condition_id].empty?
		  	result = result.where('condition_id = ? ', filter_pararms[:condition_id].to_f)
	  	end

	  	if params.key?(:raffle_status_id) && !params[:raffle_status_id].empty?
	  		result = result.where('raffle_status_id = ? ', filter_pararms[:raffle_status_id].to_f)
		end

	    if params.key?(:draw_date_initial) && params.key?(:draw_date_final) &&
	       !params[:draw_date_initial].empty? && !params[:draw_date_final].empty?
			result = result.where('draw_date BETWEEN ? AND ? ', DateTime.strptime(params[:draw_date_initial], '%d/%m/%Y'), DateTime.strptime(params[:draw_date_final], '%d/%m/%Y'))
		elsif params.key?(:draw_date_initial) && !params[:draw_date_initial].empty? 
			result = result.where('draw_date >= ? ', DateTime.strptime(params[:draw_date_initial], '%d/%m/%Y'))
		elsif params.key?(:draw_date_final) && !params[:draw_date_final].empty?
			result = result.where('draw_date <= ? ', DateTime.strptime(params[:draw_date_final], '%d/%m/%Y'))
	    end

	    if params.key?(:unit_value_min) && params.key?(:unit_value_max) &&
	       !params[:unit_value_min].empty? && !params[:unit_value_max].empty?
	    	result = result.where('unit_value BETWEEN ? AND ? ', params[:unit_value_min].to_f, params[:unit_value_max].to_f)
	    elsif params.key?(:unit_value_min) && !params[:unit_value_min].empty?
	    	result = result.where('unit_value >= ? ', params[:unit_value_min].to_f)
	    elsif params.key?(:unit_value_max) && !params[:unit_value_max].empty?
	    	result = result.where('unit_value <= ? ', params[:unit_value_max].to_f)
	    end

	    result
	  end

end