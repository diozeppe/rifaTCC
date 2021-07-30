# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  #skip_before_action :check_user, except: [:new, :create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @user = User.new(user_params)

    if (params[:tos] == false || !params[:tos].present?)
      respond_to do |format|
      format.json {render :json => {:model => "", :error => {:tos => ["Você precisa aceitar os termos de uso"]}}, :status => 422}
      format.html {render 'sign_up'}
      end
      return
    end

    if @user.save
      sign_in(resource)
      redirect_to profile_user_path(resource)
    else
      respond_to do |format|
      format.json {render :json => {:model => @user.class.name.downcase, :error => @user.errors.as_json}, :status => 422}
      format.html {render 'sign_up'}
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end 

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    sign_in_path(@user)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

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
      :city,
      :state,
      :zipCode,
      :phone_number,
      :cellphone_number)
  end

end
