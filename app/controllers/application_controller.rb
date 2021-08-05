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

	def get_cities_by_uf
		state_id = params[:state_id]

		cities = City.where('state_id = ?', state_id)

		respond_to do |format|
			format.json {render :json => cities.to_json(:only => [:id, :name])}
		end
	end

	def get_cities_by_cep
		cep = params[:cep].tr('^0-9', '')

    	if cep.length != 8
    		respond_to do |format|
    			format.json {render :json => viacep_response}
    		end
    		return
    	end

    	http = Net::HTTP.new('viacep.com.br', 80)

    	viacep_response = JSON.parse http.get('/ws/' + cep + '/json/').body

    	puts 'Retorno ' + viacep_response.to_s

    	if viacep_response['erro'] == true
    		respond_to do |format|
    			format.json {render :json => viacep_response}
    		end
    		return
    	end

		code = viacep_response['ibge']

		city = City.find_by(:code => code)

		cities = city.state.cities

		respond_to do |format|
			format.json {render :json => {:state_id => city.state_id,
				                          :city_id  => city.id,
				                          :cities   => cities.to_json(:only => [:id, :name]),
				                          :viacep   => viacep_response
				                      	 }}
		end
	end

	private

	def user_not_authorized
		redirect_to root_path
	end
end
