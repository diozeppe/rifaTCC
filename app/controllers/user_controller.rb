class UserController < ApplicationController
	before_action :set_user
	before_action :clean_params, only: [:create, :update]

	#
	# Shared Actions
	#
	def new
		@user = User.new
	end

	def update
		authorize @user

		# Remove a senha caso o usuario nao informou uma nova
		if params[:user][:password] == '' && params[:user][:password_confirmation] == ''
			end_params = user_params_no_password
		else
			end_params = user_params
		end

		if @user.update(end_params)
			redirect_to :user_root, :notice => "Dados atualizados com sucesso"
		else
			respond_to do |format|
			format.json {render :json => {:model => @user.class.name.downcase, :error => @user.errors.as_json}, :status => 422}
			format.html {render 'edit'}
			end
		end		
	end

	def tickets
		authorize @user

		@validation = validate_filters

	    if @validation.empty?
	    	@raffles = get_filters.page(params[:page])
	    else
	    	@raffles = Raffle.has_ticket_owned_by_user(@user.id).page(params[:page])
	    end
	end

	#
	# User only actions
	#
	def profile
		authorize @user
	end

	private

	def set_user
		@user = pundit_user
	end

	def clean_params
		params[:user][:zipCode] = params[:user][:zipCode].tr('^0-9', '')
		params[:user][:phone_number] = params[:user][:phone_number].tr('^0-9', '')
		params[:user][:cellphone_number] = params[:user][:cellphone_number].tr('^0-9', '')
	end

	def user_params
		params.require(:user).permit(:cpf,
			:name,
			:email,
			:password,
			:password_confirmation,
			:address,
			:number,
			:complement,
			:neighborhood,
			:zipCode,
			:phone_number,
			:cellphone_number)
	end

	def user_params_no_password
		params.require(:user).permit(:cpf,
			:name,
			:email,
			:address,
			:number,
			:complement,
			:neighborhood,
			:zipCode,
			:phone_number,
			:cellphone_number)
	end

	  def filter_pararms
	  	params.permit(
        :category_id,
        :condition_id,
        :delivery_type_id,
        :title,
        :prize,
        :cnpj,
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
	  	result = Raffle.has_ticket_owned_by_user(@user.id)

	  	if params.key?(:category_id) && !params[:category_id].empty?
	  		result = result.where('category_id = ? ', filter_pararms[:category_id].to_f)
	  	end

	  	if params.key?(:condition_id) && !params[:condition_id].empty?
		  	result = result.where('condition_id = ? ', filter_pararms[:condition_id].to_f)
	  	end

	  	if params.key?(:delivery_type_id) && !params[:delivery_type_id].empty?
	  		result = result.where('delivery_type_id = ? ', filter_pararms[:delivery_type_id].to_f)
		end

        if params.key?(:title) && !params[:title].empty?
        	result = result.where('UPPER(title) LIKE ? ', '%' + filter_pararms[:title].upcase + '%')
    	end

        if params.key?(:prize) && !params[:prize].empty?
        	result = result.where('UPPER(prize) LIKE ? ', '%' + filter_pararms[:prize].upcase + '%')
    	end

        if params.key?(:cnpj) && !params[:cnpj].empty?
        	result = result.joins(:institution).where('cnpj = ? ', filter_pararms[:cnpj].tr('^0-9', ''))
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