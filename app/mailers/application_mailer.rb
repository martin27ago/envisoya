class ApplicationMailer < ActionMailer::Base
  default from: 'EnviosYa'
  layout 'mailer'

  def registry_mail (to, from)
    @from = from
    @url  = 'http://www.gmail.com'
    mail(to: to, subject: 'Te damos la bienvenida a nuestra app')
  end

  def new_shipping_mail (to,nameFrom, addressFrom, addressTo)
    @nameFrom = nameFrom
    @addressFrom = addressFrom
    @addressTo = addressTo
    @url  = 'http://www.gmail.com'
    mail(to: to, subject: 'Tienes una nueva encomienda')
  end
end
