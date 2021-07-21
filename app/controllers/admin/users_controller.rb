class Admin::UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :show, :destroy, :profile]
	before_action :clean_params, only: [:create, :update]
  
	def index
		authorize User
		@users = User.page(params[:page])
	end

	def show
		render 'edit'
	end

	def new
		authorize User
		@user = User.new
	end

	def create
		authorize User

		@user = User.new(user_params)

		if @user.save
			flash[:sucess] = "Usuário criado com sucesso"
		else
			render 'new'
		end
	end

	def edit
	   authorize User
	end

	def update
		authorize User

		# Remove a senha caso o usuario nao informou uma nova
		if params[:user][:password] == '' && params[:user][:password_confirmation] == ''
			end_params = user_params_no_password
		else
			end_params = user_params
		end

		if @user.update(end_params)
			redirect_to :admin_root, :notice => "Usuário Atualizado/Criado com sucesso"
		else
			respond_to do |format|
			format.json {render :json => {:model => @user.class.name.downcase, :error => @user.errors.as_json}, :status => 422}
			format.html {render 'edit'}
			end
		end		
	end

	def destroy
		authorize User

		@user.destroy

		flash[:danger] = "Usuário deletado com sucesso"

		redirect_to users_path
	end

	def profile
		authorize User
	end

	private

	def set_user
		@user = User.find(params[:id])
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


end