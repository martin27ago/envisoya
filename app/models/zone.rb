require 'uri'
require 'net/http'

class Zone < ActiveRecord::Base

  def self.CreateZonesAndCostZones
    url = URI("https://delivery-rates.mybluemix.net/areas")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    arr.each do |item|
      zone = Zone.new
      zone.identify = item['id']
      zone.name = item['name']
      zone.polygon = item['polygon']
      zone.save!
      item['costToAreas'].each do |cost|
          costZonesNew = Costzone.new
          costZonesNew.zoneFrom = zone.identify
          costZonesNew.zoneTo = cost[0].to_i
          costZonesNew.cost1 = cost[1]
          costZonesNew.cost2 = 0
          costZonesNew.cost3 = 0
          costZonesNew.lastUpdate = 1
          costZonesNew.save!
      end
    end
  end
end