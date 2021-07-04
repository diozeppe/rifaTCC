class Admin::InstitutionsController < ApplicationController
	before_action :set_institution, only: [:edit, :update, :show, :destroy]
	before_action :clean_params, only: [:create, :update]

	def index
		authorize Institution
		@institutions = Institution.where(:status => true).paginate(page: params[:page], per_page: 10)
	end

	def show
		render 'edit'
	end

	def new
		authorize Institution
		@institution = Institution.new
	end

	def create
		authorize Institution

		@institution = Institution.new(institution_params)

		if @institution.save
			flash[:sucess] = "Instituição criado com sucesso"
		else
			render 'new'
		end
	end

	def edit
		authorize Institution
	end

	def update
		authorize Institution

		authorize @institution

		# Remove a senha caso o usuario nao informou uma nova
		if params[:institution][:password] == '' && params[:institution][:password_confirmation] == ''
			end_params = institution_params_no_password
		else
			end_params = institution_params
		end

		if @institution.update(end_params)
			redirect_to :admin_institutions, :notice => "Instituição Atualizado/Criado com sucesso"
		else
			respond_to do |format|
			format.json {render :json => {:model => @institution.class.name.downcase, :error => @institution.errors.as_json}, :status => 422}
			format.html {render 'edit'}
			#flash.now[:danger] = "Não foi possivel criar/alterar instituição"
			end
		end	
	end

	def destroy
		authorize institution

		@institution.destroy

		flash[:danger] = "Instituição deletada com sucesso"

		redirect_to institutions_path
	end

	def institutions_approval
		authorize Institution

		@institutions = Institution.where(:status => false).paginate(page: params[:page], per_page: 10)
	end	

	def aprove_institution
		authorize Institution

		@institution = Institution.find(params[:id])

		if @institution.toggle(:status).save
			flash[:sucess] = "Instituição aprovada"
		else
			flash[:danger] = "Problema ao aprovar Instituição"
		end

		redirect_to admin_institutions_path
	end

	private

	def set_institution
		@institution = Institution.find(params[:id])
	end

	def clean_params
		params[:institution][:zipCode] = params[:institution][:zipCode].tr('^0-9', '')
		params[:institution][:phone_number] = params[:institution][:phone_number].tr('^0-9', '')
		params[:institution][:phone_number2] = params[:institution][:phone_number2].tr('^0-9', '')
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