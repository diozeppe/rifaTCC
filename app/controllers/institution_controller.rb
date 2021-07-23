class InstitutionController < ApplicationController
	before_action :set_institution

	def profile
		authorize @institution, policy_class: InstitutionPolicy
	end

	def update
		authorize @institution, policy_class: InstitutionPolicy

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

	def confirm_sended
		@raffle = Raffle.find(params[:id])

		authorize @raffle, policy_class: RafflePolicy


		@raffle.raffle_status_id = 3 # Define como aguardando recebimento
		@raffle.save()

		puts @raffle.errors.full_messages

		redirect_to institution_raffles_path
	end

	private

	def set_institution
		@institution = pundit_user
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