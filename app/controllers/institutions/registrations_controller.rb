# frozen_string_literal: true

class Institutions::RegistrationsController < Devise::RegistrationsController
  #skip_before_action :check_user, except: [:new, :create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @institution = Institution.new(institution_params)

    if (params[:tos] == false || !params[:tos].present?)
      respond_to do |format|
      format.json {render :json => {:model => "", :error => {:tos => ["Você precisa aceitar os termos de uso"]}}, :status => 422}
      format.html {render 'sign_up'}
      end
      return
    end

    if @institution.save
      sign_in(resource)
      redirect_to profile_institution_path(resource)
    else
      respond_to do |format|
      format.json {render :json => {:model => @institution.class.name.downcase, :error => @institution.errors.as_json}, :status => 422}
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
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    sign_in_path(@institution)
  end

  private

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
      :city_id,
      :phone_number,
      :phone_number2,
      :bank_number,
      :agency_number,
      :account_number,
      :qualification,
      :about,
      :tos,
      :site
      )
  end

end
