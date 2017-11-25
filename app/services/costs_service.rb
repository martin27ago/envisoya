class CostsService < ActiveRecord::Base

  def self.calculate_cost latitude_from, latitude_to, longitude_from, longitude_to, weight
    params = 'longitude_from=' + longitude_from.to_s + '&latitude_from=' + latitude_from.to_s + '&longitude_to=' + longitude_to.to_s + '&latitude_to=' + latitude_to.to_s + '&weight=' + weight.to_s
    url = URI(ENV['URLCosts'] + '/costs/calculate_cost?' + params)

    http = Net::HTTP.new(url.host, url.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['user'], ENV['password']

    response = http.request(request)

    JSON.parse(response.read_body)
  end

  def self.costs_updated

    url = URI(ENV['URLCosts'] + '/costs/is_updated')

    http = Net::HTTP.new(url.host, url.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['user'], ENV['password']

    response = http.request(request)

    JSON.parse(response.read_body)['updated']
  end

end