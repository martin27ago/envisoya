require 'uri'
require 'net/http'

class Shipping < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :delivery, class_name: "Delivery"
  enum status: [ :Pendiente, :Enviando, :Entregado, :Cancelado ]
  enum paymentMedia: [ :Contado, :Tarjeta ]
  has_attached_file :signature, styles: {thumbnail: "120x120>"}
  validates_attachment_content_type :signature, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]

  def self.PingDeliveryRate
    url = URI("https://delivery-rates.mybluemix.net/")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

    response = http.request(request)

  end

end