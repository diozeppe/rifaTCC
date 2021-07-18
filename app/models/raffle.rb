class Raffle < ApplicationRecord
  paginates_per 10

  scope :only_active, -> { where('raffle_status_id = ?', 1)}
  scope :has_ticket_owned_by_user, -> (user_id) {joins(:tickets).where(tickets: {user: user_id}).distinct}

  belongs_to :institution
  has_many :tickets
  belongs_to :winner_ticket, :class_name => 'Ticket', optional: true
  has_many_attached :images
  belongs_to :category
  belongs_to :condition
  belongs_to :delivery_type
  belongs_to :raffle_status

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

  def valid_draw_date?
    errors.add(:draw_date, 'Data inválida') if (draw_date.nil?)

    if (!draw_date.nil?)
      errors.add(:draw_date, 'Data deve ser futura') if (draw_date < Date.current && raffle_status_id == 1)
    end
  end

end