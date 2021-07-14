class CreateRaffle < ActiveRecord::Migration[5.1]
  def change
    create_table     :raffles do |t|
    	  t.integer    :institution_id
        t.integer    :user_id, default: 1
    	  t.integer    :category_id, default: 1
        t.integer    :condition_id, default: 1
        t.integer    :raffle_status_id, default: 1
        t.integer    :delivery_type_id, default: 1
        t.integer    :winner_ticket_id, null: true
        t.string     :title
    	  t.text       :description
        t.string     :prize
        t.text       :prize_description
    	  t.float      :unit_value, default: 0
        t.integer    :tickets_number, default: 0
        t.integer    :tickets_sold, default: 0
    	  t.datetime   :draw_date
        t.timestamps
    end
  end
end
