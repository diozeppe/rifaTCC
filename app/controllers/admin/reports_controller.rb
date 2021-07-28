class Admin::ReportsController < ApplicationController
	def general
		respond_to do |format|
			format.json {render :json => {:model => "TESTE"}}
			format.html {render 'general'}
		end
	end

	def sales
		
	end

	def registrations

	end

	def revenue
		
	end


	#
	# Ajax for charts
	# 
	def get_sales
		get_filters

		if (!@initial_period.nil? && !@final_period.nil?)
			result = Ticket.where('purchase_date BETWEEN ? AND ? ', DateTime.strptime(@initial_period, '%d/%m/%Y'), DateTime.strptime(@final_period, '%d/%m/%Y'))
		elsif (!@initial_period.nil?)
			result = Ticket.where('purchase_date >= ? ', DateTime.strptime(@initial_period, '%d/%m/%Y'))
		else
			result = Ticket.where('purchase_date >= ? ', DateTime.now - 7.days)
		end

		if (!@institution.nil?)
			result = result.joins(:raffle).where('institution_id = ?', @institution.id);
		end

		if (!@raffe_status.nil?)
			result = result.joins(:raffle).where('raffle_status_id = ?', @raffe_status)
		end

		if (!@raffe_category.nil?)
			result = result.joins(:raffle).where('category_id = ?', @raffe_category)
		end

		#result.joins(:raffle).group('extract(year from purchase_date)').group('extract(month from purchase_date)').group('extract(day from purchase_date)').sum('tickets_sold * unit_value')

		result = result.joins(:raffle).group("TRIM(TO_CHAR(purchase_date, 'Month')) || ', ' || extract(day from purchase_date)").sum('unit_value')

        #
        # Define labels base do chart
        #
        labels = []
        result.each do |k, v|
          labels.push(k)
        end

        #
        # Preenche os datas sets
        #
        datasets = []

		dset = []

		labels.each do |v|
			dset.push(result[v])
		end

		#
        # complementa o dataset
        #
		dataset = {
				   :label => 'Cotas', 
				   :backgroundColor => '#fed18c',
			       :borderColor => '#AA8774',
			       :data => dset
			      }

		datasets.push(dataset)

		chart = {
				 :type    => 'line',
			     :options => {:responsive => true},
			     :data => {:labels => labels, :datasets => datasets}
			 	}

		puts chart

		render json: chart.to_json
	end

	def get_user_registrations
		get_filters

		result = User.where('created_at >= ? ', DateTime.now - 15.days).group("TRIM(TO_CHAR(created_at, 'Month')) || ', ' || extract(day from created_at)").count
        #
        # Define labels base do chart
        #
        labels = []
        result.each do |k, v|
          labels.push(k)
        end

        #
        # Preenche os datas sets
        #
        datasets = []

		dset = []

		labels.each do |v|
			dset.push(result[v])
		end

		#
        # complementa o dataset
        #
		dataset = {
				   :label => 'Usuarios', 
				   :backgroundColor => '#fed18c',
			       :borderColor => '#AA8774',
			       :data => dset
			      }

		datasets.push(dataset)

		chart = {:type    => 'bar',
			     :options => {:responsive => true},
			     :data => {:labels => labels, :datasets => datasets}
			 	}

		puts chart

		render json: chart.to_json
	end

	def get_institution_registrations
		get_filters

		result = Institution.where('created_at >= ? ', DateTime.now - 15.days).group("TRIM(TO_CHAR(created_at, 'Month')) || ', ' || extract(day from created_at)").count

        #
        # Define labels base do chart
        #
        labels = []
        result.each do |k, v|
          labels.push(k)
        end

        #
        # Preenche os datas sets
        #
        datasets = []

		dset = []

		labels.each do |v|
			dset.push(result[v])
		end

		#
        # complementa o dataset
        #
		dataset = {
				   :label => 'Instituições', 
				   :backgroundColor => '#fed18c',
			       :borderColor => '#AA8774',
			       :data => dset
			      }

		datasets.push(dataset)

		chart = {:type    => 'bar',
			     :options => {:responsive => true},
			     :data => {:labels => labels, :datasets => datasets}
			 	}

		puts chart

		render json: chart.to_json
	end

	private

	def validate_filters
		errors = {}

	  	if !@initial_period.nil?
	  		begin
	  			DateTime.strptime(@raffle_initial_value, '%d/%m/%Y')
	  		rescue StandardError
	  			errors[:initial_period] = "Data inválida"
	  		end
	  	end

	  	if !@final_period.nil?
	  		begin
	  			DateTime.strptime(final_period, '%d/%m/%Y')
	  		rescue StandardError
	  			errors[:final_period] = "Data inválida"
	  		end
	  	end

	  	if !@institution_cnpj.nil?
	  		if (CNPJ.valid?(@institution_cnpj))
	  			errors[:institution_cnpj] = "CNPJ inválido"

	  		else
	  			@institution = Institution.find_by(cnpj: institution_cnpj)
	  			if @institution.empty?
	  				errors[:institution_cnpj] = "CNPJ não cadastrado"
	  			end
	  		end
	  	end

	  	errors
	 end

	def get_filters
		@raffle_initial_value  = params[:initial_value]    if params[:initial_value].present?
		@raffle_final_value    = params[:final_value]      if params[:final_value].present?
		@initial_period        = params[:initial_period]   if params[:initial_period].present?
		@final_period          = params[:final_period]     if params[:final_period].present?
		@raffe_status          = params[:raffle_status]    if params[:raffle_status].present?
		@raffe_category        = params[:raffe_category]   if params[:raffe_category].present?
		@institution_cnpj      = params[:institution_cnpj] if params[:institution_cnpj].present?

		validate_filters
	end
end