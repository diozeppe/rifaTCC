class Raffle < ApplicationRecord
  paginates_per 10

  TICKETS_NUMBER_OPTIONS = [100, 1000]

  scope :only_active, -> { where('raffle_status_id = ?', 1)}
  scope :only_finished, -> { where('raffle_status_id = ?', 4)}
  scope :has_ticket_owned_by_user, -> (user_id) {joins(:tickets).where(tickets: {user: user_id, ticket_status_id:  3}).distinct}

  belongs_to :institution
  belongs_to :category
  belongs_to :condition
  belongs_to :delivery_type
  belongs_to :raffle_status
  belongs_to :winner_ticket, :class_name => 'Ticket', optional: true

  has_many :tickets
  has_many_attached :images

  validates :title, presence: true,
                    length: {
                      minimum: 10,
                      maximum: 200
                    }

  validates :description, presence: true,
                          length: { minimum: 10,
                                    maximum: 10000 
                                  }

  validates :prize,  presence: true,
                     length: {
                              minimum: 10,
                              maximum: 200
                            }

  validates :prize_description,  presence: true,
                     length: {
                              minimum: 10,
                              maximum: 10000
                            }

  validates :unit_value,  presence: true

  validates :tickets_number,  presence: true

  validate :valid_draw_date?

  validate :valid_tickets_number

  def valid_draw_date?
    errors.add(:draw_date, 'Data inválida') if (draw_date.nil?)

    if (!draw_date.nil?)
      errors.add(:draw_date, 'Data deve ser futura') if (draw_date < Date.current && raffle_status_id == 1)
    end
  end

  def valid_tickets_number?
    if ![100, 1000].include?(tickets_number)
      errors.add(:tickets_number, 'A quantidade de cotas deve ser 100 ou 1000')
    end
  end

end