require 'uri'
require 'net/http'

class Cost < ActiveRecord::Base
  def self.UpdateCost
    url = URI("https://delivery-rates.mybluemix.net/cost")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cost = Cost.where(["id = ?", 1]).first

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    newCost = arr['cost']
    cost.cost = newCost
    cost.save!
  end
end