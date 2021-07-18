class CreateInstitution < ActiveRecord::Migration[5.1]
  def change
    create_table  :institutions do |t|
      	t.string  :cnpj
        t.string  :email
        t.string  :encrypted_password
      	t.string  :corporate_name
        t.string  :social_reason
        t.string  :address
        t.string  :number
        t.string  :complement
        t.string  :neighborhood
        t.string  :zipCode
        t.integer :city_id
        t.string  :phone_number
        t.string  :phone_number2
        t.integer :bank_number
        t.integer :agency_number
        t.integer :account_number
    	  t.string  :qualification
        t.string  :city
        t.string  :state
        t.string  :site
        t.text    :about
        t.boolean :status, default: false

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.inet     :current_sign_in_ip
        t.inet     :last_sign_in_ip

        ## Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email # Only if using reconfirmable

    	  # Colunas padrao do rails
    	  t.datetime :created_at
    	  t.datetime :updated_at
    end
  end
end
