require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  tickets_on_hold = Ticket.only_on_hold_session

  puts 'Rodou o update'

  tickets_on_hold.each do |t|
    t.update_at > 5.minutes.ago
    t.ticket_status_id = 1
    t.save()
  end
end