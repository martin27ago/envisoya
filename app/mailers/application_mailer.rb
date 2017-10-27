class ApplicationMailer < ActionMailer::Base
  default from: 'EnviosYa'
  layout 'mailer'

  def registry_mail (to, from)
    @from = from
    @fromId = from.id.to_s
    @url  = 'http://www.gmail.com'
    mail(to: to, subject: 'Te damos la bienvenida a nuestra app')
  end

  def send_shipping_confirmation(shipping, user)
    @user = user
    @shipping = shipping
    mail(to: user.email, subject: "Confirmación de envío")
  end

  def new_shipping_mail (to,nameFrom, addressFrom, addressTo)
    @nameFrom = nameFrom
    @addressFrom = addressFrom
    @addressTo = addressTo
    @url  = 'http://www.gmail.com'
    mail(to: to, subject: 'Tienes una nueva encomienda')
  end

  def shipping_delivered (shipping)
    @shipping = shipping
    @user = shipping.user
    email = @user.email
    html = '<h1>Se entrego tu pedido!</h1> <br> <p>Desde: ' + @shipping.addressFrom + '</p> <br><p> Hasta: <p>' + @shiiping.addressTo + '</p><br><p>Con un precio de:' + @shipping.price+'</p>'
    pdfShipped = WickedPdf.new.pdf_from_string(html)

    mail(to:email, subject: "Pedido entregado con éxito") do |format|
      format.pdf {attachments['Confirmation']=pdfShipped}
    end
  end
end
