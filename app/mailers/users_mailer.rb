class UsersMailer < ActionMailer::Base
  default from: 'rifaAmigaUFPR@gmail.com'
  default :template_path => 'users/mailer'

  def raffle_bought
    @user = params[:user]
    @raffle = params[:raffle]
    @tickets = params[:tickets]
  end

  def raffle_result_lost
    @user = params[:user]
    @raffle = params[:raffle]

    mail(to: @user.email, subject: "Resultado do sorteio: " + @raffle.title)
  end

  def raffle_result_winner
    @user = params[:user]
    @raffle = params[:raffle]

    mail(to: @user.email, subject: "Resultado do sorteio: " + @raffle.title)
  end

  def institution_sent_prize
    @raffle = params[:raffle]
    @user = params[:user]
    @institution = params[:institution]

    mail(to: @user.email, subject: "A " + @institution.name + " já enviou seu prêmio ")
  end

end
