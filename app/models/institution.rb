class Institution < ApplicationRecord
  paginates_per 10
  
  has_many :raffles

  before_save { self.email = email.downcase }

  devise :database_authenticatable,
         :registerable, 
         :confirmable,
         :recoverable, 
         :rememberable, 
         :trackable,
         :validatable

  validates :cnpj, presence: true, 
                   uniqueness: true

  validate :cnpj_valid?

  validates :corporate_name, presence: true,
						                 length: { maximum: 100 }

  validates :address, presence: true, 
                      length: { maximum: 100 }

  validates :number, presence: true, 
                     length: { maximum: 6 }

  validates :complement, length: { maximum: 50 }

  validates :neighborhood, presence: true, 
                           length: { maximum: 50}  

  validates :zipCode, presence: true, 
                      length: { maximum: 8 }


  def self.not_approved_count
    where(:status => false).size
  end

  private

  def cnpj_valid?
    if !(CNPJ.new(self.cnpj).valid?)
      errors.add(:cnpj, "CNPJ invalido")
    end
  end

end