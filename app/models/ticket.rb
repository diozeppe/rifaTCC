class Ticket < ApplicationRecord
  paginates_per 100

  scope :only_open, -> { where('ticket_status_id = ?', 1)}
  scope :only_open_or_owned, -> (user_id) { where('ticket_status_id = ? OR user_id = ?', 1, user_id).order("number")}
  scope :only_owned_on_hold, -> (user_id) { where('user_id = ? AND ticket_status_id = 2', user_id).order("number")}
  scope :only_owned, -> (user_id) { where('user_id = ? AND ticket_status_id = 3', user_id).order("number")}
  scope :only_on_hold_session, -> { where('ticket_status_id = ?', 2)}

  belongs_to :raffle
  belongs_to :user, optional: true
  belongs_to :ticket_status

  def get_status_class
    case ticket_status_id
      when 1
        "ticket-open"
      when 2
        "ticket-on-hold"
      when 3
        "ticket-finished"
      end
  end

  def open?
    ticket_status_id == 1
  end
end