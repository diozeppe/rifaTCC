class InstitutionController < ApplicationController
	before_action :set_institution
	before_action :clean_params, only: [:create, :update]

	def profile
		authorize @institution, policy_class: InstitutionPolicy
	end

	def show
		
	end

	def edit
		authorize Institution
	end

	def update
		authorize @institution

		# Remove a senha caso o usuario nao informou uma nova
		if params[:institution][:password] == '' && params[:institution][:password_confirmation] == ''
			end_params = institution_params_no_password
		else
			end_params = institution_params
		end

		if @institution.update(end_params)
			redirect_to institution_path, :notice => "Atualizado com sucesso"
		else
			respond_to do |format|
			format.json {render :json => {:model => @institution.class.name.downcase, :error => @institution.errors.as_json}, :status => 422}
			format.html {render 'edit'}
			end
		end	
	end

	private

	def set_institution
		@institution = pundit_user
	end

	def clean_params
		params[:institution][:zipCode] = params[:institution][:zipCode].tr('^0-9', '')
		params[:institution][:phone_number] = params[:institution][:phone_number].tr('^0-9', '')
		params[:institution][:phone_number2] = params[:institution][:phone_number2].tr('^0-9', '')
		params[:institution][:agency_number] = params[:institution][:agency_number].tr('^0-9', '')
		params[:institution][:account_number] = params[:institution][:account_number].tr('^0-9', '')
	end

	def institution_params
		params.require(:institution).permit(
			:cnpj,
			:email,
			:password,
			:password_confirmation,
			:corporate_name,
			:social_reason,
			:address,
			:number,
			:complement,
			:neighborhood,
			:zipCode,
			:phone_number,
			:phone_number2,
			:bank_number,
			:agency_number,
			:account_number,
			:qualification
			)
	end

	def institution_params_no_password
		params.require(:institution).permit(
			:cnpj,
			:email,
			:corporate_name,
			:social_reason,
			:address,
			:number,
			:complement,
			:neighborhood,
			:zipCode,
			:phone_number,
			:phone_number2,
			:bank_number,
			:agency_number,
			:account_number,
			:qualification
			)
	end
end