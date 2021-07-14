require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  tickets_on_hold = Ticket.only_on_hold_session

  puts 'Rodou o update'

  tickets_on_hold.each do |t|
    t.update_at > 5.minutes.ago
    t.user_id = 0
    t.ticket_status_id = 1
    t.save()
  end
end

scheduler.every '1m' do
  raffles_to_set_result = Raffle.where('raffle_status_id = ? AND draw_date < ?', 1, DateTime.now)

  puts 'Buscando rifas para sortear'

  raffles_to_set_result.each do |r|
    while true do 
      ticketsToDraw = r.tickets.where('user_id <> 0')
      #
      # Caso ninguem tenha comprado, cancela a rifa
      #
      if (ticketsToDraw.empty?)
        r.raffle_status_id = 5
        r.save
        break
      end

      result = rand(0..(ticketsToDraw.length()-1))

      puts 'Buscando numero'

      t = ticketsToDraw[result]

      if (!t.nil?)
        puts 'Atualizou'

        r.winner_ticket_id = t.id
        r.raffle_status_id = 2

        # TODO
        # Faz envio de email
        #

        r.save()
        break
      end
    end
  end
end