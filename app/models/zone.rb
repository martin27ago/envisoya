require 'uri'
require 'net/http'

class Zone < ActiveRecord::Base
  def self.UpdateZones
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
      #item['costToAreas'].each do |cost|
       # costZones = Costzone.new
        #costZones.zoneFrom = zone.identify
        #costZones.zoneTo = cost[0].to_i
        #costZones.cost = cost[1]
        #costZones.save!
      #end
    end
  end
end