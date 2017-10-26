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

  def self.CalculateCost longitudeFrom, latitudeFrom, longitudeTo, latitudeTo, weight
    sql = 'SELECT * FROM zones WHERE st_contains(ST_GeomFromText(zones.polygon), ST_GeomFromText(?))'

    point = 'POINT('+latitudeFrom+''+longitudeFrom+')'
    zoneFrom = Zone.find_by_sql([sql, point]).first.id

    pointTo = 'POINT('+latitudeTo+''+longitudeTo+')'
    zoneTo = Zone.find_by_sql([sql, pointTo]).first.id

    auxCostWeight = Cost.where(["id = 1"]).first
    costWeight = 0
    costZone = 0
    timeDiff = ((Time.now-auxCostWeight.updated_at)* 24 * 60).to_i
    if(timeDiff > 10)
      costWeight = (auxCostWeight.cost1 + auxCostWeight.cost2 + auxCostWeight.cost3) / 3
      else
      if(auxCostWeight.lastUpdate==1)
        costWeight = auxCostWeight.cost1
      else if(auxCostWeight.lastUpdate == 2)
             costWeight = auxCostWeight.cost2
             else
               costWeight = auxCostWeight.cost3
             end
      end
    end
    if (zoneFrom==zoneTo)
      costZone = 0
    else
      auxCostZone = Costzone.where(["zoneFrom = ? and zoneTo = ?", zoneFrom, zoneTo]).first
      timeDiff = ((Time.now-auxCostZone.updated_at)* 24 * 60).to_i
      if(timeDiff > 10)
        costZone = (auxCostZone.cost1 + auxCostZone.cost2 + auxCostZone.cost3) / 3
      else
        if(auxCostZone.lastUpdate==1)
          costZone = auxCostZone.cost1
        else if(auxCostZone.lastUpdate == 2)
               costZone = auxCostZone.cost2
             else
               costZone = auxCostZone.cost3
             end
        end
      end
    end
    (weight.to_i * costWeight) + costZone
  end


end