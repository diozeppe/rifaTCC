class InstitutionsMailer < ActionMailer::Base
  default from: 'rifaAmigaUFPR@gmail.com'
  default :template_path => 'intitutions/mailer'

  def raffle_drew
  	@institution = params[:institution]
  	@raffle = params[:raffle]

  	mail(to: @institution.email, subject: "Sorteio realizado para: " + @raffle.title)
  end

  def user_confirmed_delivery
    @raffle = params[:raffle]
    @institution = params[:institution]

    mail(to: @institution.email, subject: "O ganhador confirmou o recebimento: " + @raffle.title)
  end

  def institution_approved
    @institution = params[:institution]
    mail(to: @institution.email, subject: "Seu cadastro foi aprovado")
  end

end