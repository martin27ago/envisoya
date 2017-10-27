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
    @delivery= shipping.delivery
    email = @user.email
    html = '<h1>Se entrego tu pedido!</h1> <br> <p> <strong>Hora emitido:</strong> '+ @shipping.created_at.to_s + '</p><br><p><strong>Hora entregado: </strong>'+ @shipping.updated_at.to_s + '</p><br><p><strong>Usuario Remitente: </strong>' + @user.name.to_s + '</p><br><p><strong>Destinatario: </strong>'+ @shipping.emailTo.to_s + '</p><br><p><strong>Cadete Responsable: </strong>'+ @delivery.name.to_s + '</p><br><p><strong>Desde: </strong>' + @shipping.addressFrom.to_s + '</p> <br><p> <strong>Hasta: </strong>' + @shipping.addressTo.to_s + '</p><br><p><strong>Con un precio de:</strong> $' + @shipping.price.to_s + '</p><br><br><p>Muchas gracias!!<br> <strong>Envios Ya</strong></p>'
    #html ='<h1>hola</h1>'
    pdfShipped = WickedPdf.new.pdf_from_string(html)
    attachments['Confirmacion.pdf'] = {:mime_type => 'application/pdf',
                                         :content => pdfShipped }
    mail(to: email, subject: "Pedido entregado con éxito")
  end
end
