class HomeController < ApplicationController
	before_action :clean_params, only: [:access_user, :access_institution]

	def home
		
	end

	def log_in
		if pundit_user.nil?
			render "sign_in"
		else
			redirect_to root_path
		end
	end

	def access_user
		if (CPF.valid?(login_params[:cpf]))
			@user = User.find_by(cpf: login_params[:cpf])

			if !@user.nil? 
				if @user.valid_password?(login_params[:password])
					sign_in :user, @user
					redirect_to root_path
				end
			else
				flash[:danger] = "CPF não cadastrado ou senha inválida"
				redirect_back(fallback_location: sign_in_path)
			end
		else
			flash[:danger] = "CPF Inválido"
			redirect_back(fallback_location: sign_in_path)
		end 
	end

	def access_institution
		if (CNPJ.valid?(login_params[:cnpj]))
			@institution = Institution.find_by(cnpj: login_params[:cnpj])

			if !@institution.nil? 
				if @institution.valid_password?(login_params[:password])
					sign_in :institution, @institution
					redirect_to root_path
				end
			else
				flash[:danger] = "CNPJ nao cadastrado ou senha inválida"
				redirect_back(fallback_location: sign_in_path)
			end
		else
			flash[:danger] = "CNPJ Inválido"
			redirect_back(fallback_location: sign_in_path)
		end 
	end

	private

	def login_params
		params.permit(:cpf, :cnpj, :password, :remember_me, :authenticity_token, :utf8, :commit)
	end

	def clean_params
		params[:cpf] = params[:cpf].tr('^0-9', '') if params.key?(:cpf)
		params[:cnpj] = params[:cnpj].tr('^0-9', '') if params.key?(:cnpj)
	end
	
end
