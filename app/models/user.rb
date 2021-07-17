class User < ApplicationRecord
  has_one :wallet
  has_many :tickets

  devise :database_authenticatable,
         :registerable,
         :confirmable,
         :recoverable, 
         :rememberable, 
         :trackable,
         :validatable

  before_save { 
    self.email = email.downcase
   }

  validates :cpf, presence: true, 
                  uniqueness: true

  validate :cpf_valid?

  validates :name, presence: true, 
                   length: { maximum: 80 }

  validates :address, presence: true, 
                      length: { maximum: 100 }

  validates :number, presence: true, 
                     length: { maximum: 6 }

  validates :complement, length: { maximum: 50 }

  validates :neighborhood, presence: true, 
                           length: { maximum: 50}  

  validates :zipCode, presence: true, 
                      length: { maximum: 8 }

  def cep_formated
    self.zipCode[0..4] + '-' + self.zipCode[5..8]
  end

  def get_address_formated
    self.address + ', ' + self.number + ' - ' + self.neighborhood + ', ' + self.city + ' - ' + self.state + ', ' + self.cep_formated
  end

  private

  def cpf_valid?
    if !(CPF.new(self.cpf).valid?)
      errors.add(:cpf, "CPF invalido")
    end
  end

end