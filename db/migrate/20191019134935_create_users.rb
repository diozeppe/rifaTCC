class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.string :cpf
    	t.string :name
    	t.string :email, default: "", null: false
    	t.string :encrypted_password, default: "", null: false
    	t.string :address
    	t.string :number
    	t.string :complement
    	t.string :neighborhood
    	t.string :zipCode
    	t.string :phone_number
    	t.string :cellphone_number
    	t.integer :city_id

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

    	t.timestamps
    end
  end
end
