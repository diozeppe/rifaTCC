class Raffle < ApplicationRecord
  scope :only_active, -> { where('raffle_status_id = ?', 1)}

  belongs_to :institution
  has_many :tickets
  has_many_attached :images
  belongs_to :category
  belongs_to :condition
  belongs_to :delivery_type
  belongs_to :raffle_status

  validates :title, presence: true,
                    length: {
                      minimum: 10,
                      maximum: 100
                    }

  validates :description, presence: true,
                          length: { minimum: 10,
                                    maximum: 500 
                                  }

  validates :prize,  presence: true,
                     length: {
                              minimum: 10,
                              maximum: 30
                            }

  validates :prize_description,  presence: true,
                     length: {
                              minimum: 10,
                              maximum: 200
                            }

  validates :unit_value,  presence: true

  validates :tickets_number,  presence: true

  validate :valid_draw_date?

  def valid_draw_date?
    errors.add(:draw_date, 'Data inválida') if (draw_date.nil?)

    if (!draw_date.nil?)
      errors.add(:draw_date, 'Data deve ser futura') if (draw_date < Date.current)
    end
  end

end