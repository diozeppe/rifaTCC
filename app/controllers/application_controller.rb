class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	include Pundit

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	def after_sign_in_path_for(resource)
		if resource.instance_of? Admin
			admin_root_path
		elsif resource.instance_of? Institution
			profile_institution_path
		elsif resource.instance_of? User
			profile_user_path
		end
	end

	def pundit_user
		if admin_signed_in?
			current_admin
		elsif institution_signed_in?
			current_institution
		elsif user_signed_in?
			current_user
		else
			nil
		end
	end

	private

	def user_not_authorized
		redirect_to root_path
	end
end
