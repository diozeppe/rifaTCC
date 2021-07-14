class RafflesController < ApplicationController
	before_action :set_user
	before_action :set_raffle, only: [:show, :buy, :check_tickets, :checkout, :cancel, :finish]

	def index
	  @validation = validate_filters

	  if @validation.empty?
	  	@raffles = get_filters.page(params[:page])
	  else
	  	@raffles = Raffle.only_active.page(params[:page])
	  end
	end

	def show
	  
	end

	def buy
	  @tickets = @raffle.tickets.only_owned_on_hold(@user)

	  if (!@tickets.empty?)
	  	redirect_to raffles_checkout_path(@raffle)
	  else
	  	@tickets = @raffle.tickets.only_open.page(params[:page])
	  end
	end

	def check_tickets
		#
		# Lista de numeros a serem verificados
		#
		ticket_list = params[:selected_tickets_hidden].split(';')

		#
		# Lista de numeros que ja foram pegos
		#
		alreadyTakenList = []

		#
		# Lista dos tickets realmente encontrados via params
		#
		ticketsFound = []

		ticket_list.each_with_index do |v,i|
			#
			# Tenta buscar se o numero realmente e valido
			#
			t = @raffle.tickets.where('number = ?', v).first
			if (!t.nil?)
				#
				# Caso encontre, coloca na lista de encontrados
				#
				ticketsFound << t
				if !t.open?
				  #
				  # Caso esteja ocupado, zera o valor e adiciona o numero na lista ṕara informar o usuario
				  #
				  ticket_list[i] = '';
				  alreadyTakenList.push(v)
				end
			else
				#
				# numero nao valido, remove
				#
				ticket_list[i] = '';
			end
		end

		#
		# Remove os invalidos da lista
		#
		ticket_list.delete("");

		#
		# Caso o numero que o usuario informou foi pego no caminho, retira da lista e informa
		#
		if (alreadyTakenList != [])
			respond_to do |format|
			format.json {render :json => {:newTicketList => ticket_list.join(';'), :alreadyTaken => alreadyTakenList.join(',')}, :status => 422}
			format.html {render 'buy'}
			end
		else
			#
			# Se chegou aqui, seta os numeros como on_hold_session e com o id od usuario para checkout
			#
			ticketsFound.each do |t|
				t.user_id = @user.id
				t.ticket_status_id = 2
				t.save()
			end

			redirect_to raffles_checkout_path(@raffle)
		end
	end

	def checkout
		@tickets = @raffle.tickets.only_owned_on_hold(@user)
	end

	def cancel
		#
		# Atualiza status do ticket
		#
		@tickets = @raffle.tickets.only_owned_on_hold(@user)

		@tickets.each do |t|
			t.ticket_status_id = 1
			t.save()
		end

		redirect_to raffles_buy_path(@raffle)
	end

	def finish
		#
		# Atualiza status do ticket
		#
		@tickets = @raffle.tickets.only_owned_on_hold(@user)

		@tickets.each do |t|
			t.ticket_status_id = 3
			t.save()
		end

		#
		# Atualiza unidades vendidas da rifa
		#
		@raffle.tickets_sold += @tickets.length
		@raffle.save()

		redirect_to tickets_user_path
	end

	private

	  def set_user
	  	@user = pundit_user
	  end

	  def set_raffle
	  	@raffle = Raffle.find(params[:id])
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
	  	result = Raffle.only_active

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