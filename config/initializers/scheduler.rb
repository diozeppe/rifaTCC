require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  tickets_on_hold = Ticket.only_on_hold_session

  puts 'Rodou o update'

  tickets_on_hold.each do |t|
    t.updated_at > 5.minutes.ago
    t.user_id = 0
    t.ticket_status_id = 1
    t.save()
  end
end

scheduler.every '1m' do
  raffles_to_set_result = Raffle.where('raffle_status_id = ? AND draw_date < ?', 1, DateTime.now)

  puts 'Buscando rifas para sortear'

  raffles_to_set_result.each do |raffle|
    while true do 
      ticketsToDraw = raffle.tickets.where('user_id <> 0')
      #
      # Caso ninguem tenha comprado, cancela a rifa
      #
      if (ticketsToDraw.empty?)
        raffle.raffle_status_id = 5
        raffle.save
        break
      end

      result = rand(0..(ticketsToDraw.length()-1))

      puts 'Buscando numero'

      winner_ticket = ticketsToDraw[result]

      if (!winner_ticket.nil?)
        puts 'Atualizou'

        raffle.winner_ticket_id = winner_ticket.id
        raffle.raffle_status_id = 2

        # TODO
        # Faz envio de email
        #

        #
        # Email para a instituição
        #
        InstitutionMailer.with(institution: raffle.institution, raffle: raffle).raffle_drew.deliver_later

        #
        # Email do ganhador
        #
        winner_user = User.find(winner_ticket.user_id);

        UsersMailer.with(user: winner_ticket.user, raffle: raffle).raffle_result_winner.deliver_later

        #
        # Email dos outros usuarios
        #
        other_users = User.get_except_winner(raffle, winner_ticket.user)

        other_users.each do |user|
          UsersMailer.with(user: user, raffle: raffle).raffle_result_loss.deliver_later
        end

        r.save()
        break
      end
    end
  end
end