require 'uri'
require 'net/http'

class Shipping < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :delivery, class_name: "Delivery"
  enum status: [ :Pendiente, :Entregado, :Cancelado ]
  enum paymentMedia: [ :Contado, :Tarjeta ]
  has_attached_file :signature, styles: {thumbnail: "120x120>"}
  validates_attachment_content_type :signature, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.PingDeliveryRate
    url = URI("https://delivery-rates.mybluemix.net/")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

    response = http.request(request)

  end

  def self.CalculateCost longitudeFrom, latitudeFrom, longitudeTo, latitudeTo, weight, user_id
    estimatedPrice = false
    sql = 'SELECT * FROM zones WHERE st_contains(ST_GeomFromText(zones.polygon), ST_GeomFromText(?))'

    point = 'POINT('+latitudeFrom+''+longitudeFrom+')'
    zoneFrom = Zone.find_by_sql([sql, point]).first.identify.to_i

    pointTo = 'POINT('+latitudeTo+''+longitudeTo+')'
    zoneTo = Zone.find_by_sql([sql, pointTo]).first.identify.to_i

    auxCostWeight = Cost.where(["id = 1"]).first
    costWeight = 0
    costZone = 0
    time=10.minutes.ago
    if(auxCostWeight.updated_at < 10.minutes.ago)
      estimatedPrice = true
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
      auxCostZone = Costzone.where(["\"zoneFrom\" = ? and \"zoneTo\" = ?", zoneFrom, zoneTo]).first
      if(auxCostZone.updated_at < 10.minutes.ago)
        estimatedPrice=true
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

    discount = Discount.where(["active = ? and used = ? and user_id = ?", true, false, user_id]).first
    percentageDiscount =0
    if(!discount.nil?)
      percentageDiscount = discount.porcent
    end
    price =(weight.to_i * costWeight) + costZone
    result = { 'discount' => percentageDiscount, 'price' => price, 'estimatedPrice' => estimatedPrice }

  end

  def self.ConfirmPrice
    costWeight = Cost.where(["id = 1"]).first
    costZones = Costzone.where(["id = 1"]).first
    if costZone.updated_at>10.minutes.ago && costWeight.updated_at>10.minutes.ago
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 0])
      shippings.each do |shipping|
        cost = shipping.UpdateCost shipping
        shipping.cost = cost
        shipping.estimatedPrice=false
        shipping.save!
        user = shipping.user
        User.SendConfirmationMail shipping, user
      end
    end
  end

  def UpdateCost shipping
    point = 'POINT('+shipping.latitudeFrom+''+shipping.longitudeFrom+')'
    zoneFrom = Zone.find_by_sql([sql, point]).first.identify.to_i

    pointTo = 'POINT('+shipping.latitudeTo+''+shipping.longitudeTo+')'
    zoneTo = Zone.find_by_sql([sql, pointTo]).first.identify.to_i

    costZones = Costzone.where(["\"zoneFrom\" = ? and \"zoneTo\" = ?", zoneFrom, zoneTo]).first
    costZone = (costZones.cost1 + costZones.cost2 + costZones.cost3) / 3

    costWeights= Cost.where(["id = 1"]).first
    costWeight = (costWeights.cost1 + costWeights.cost2 + costWeights.cost3) / 3

    (shipping.weight * costWeight) + costZone
  end

  def self.DeliveredShipping
    costWeight = Cost.where(["id = 1"]).first
    costZones = Costzone.where(["id = 1"]).first
    if costZone.updated_at > 10.minutes.ago && costWeight.updated_at > 10.minutes.ago
      shippings = Shipping.where(["\"estimatedPrice\" = ? and \"status\" = ?", true, 1])
      shippings.each do |shipping|
        cost = shipping.UpdateCost shipping
        shipping.cost = cost
        shipping.estimatedPrice=false
        shipping.save!
        user = shipping.user
        User.SendConfirmationMail shipping, user
      end
    end
  end

end