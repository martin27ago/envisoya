require 'uri'
require 'net/http'
class CostsService < ActiveRecord::Base

  def self.calculate_cost latitude_from, latitude_to, longitude_from, longitude_to, weight
    params = 'longitude_from=' + longitude_from.to_s + '&latitude_from=' + latitude_from.to_s + '&longitude_to=' + longitude_to.to_s + '&latitude_to=' + latitude_to.to_s + '&weight=' + weight.to_s
    url = URI(ENV['URLCosts'] + '/costs/calculate_cost?' + params)

    http = Net::HTTP.new(url.host, url.port)
    if Rails.env.production?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['user'], ENV['password']

    response = http.request(request)

    JSON.parse(response.read_body)
  end

  def self.costs_updated

    url = URI(ENV['URLCosts'] + '/costs/is_updated')

    http = Net::HTTP.new(url.host, url.port)
    if Rails.env.production?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['user'], ENV['password']

    response = http.request(request)

    JSON.parse(response.read_body)['updated']
  end

  def self.health_check_costs
    begin
      url = URI(ENV['URLCosts'] + '/application/healthCheck')

      http = Net::HTTP.new(url.host, url.port)
      if Rails.env.production?
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new(url)
      request.basic_auth ENV['user'], ENV['password']

      response = http.request(request)

      JSON.parse(response.read_body)['ok']
    rescue
      LoggerHelper.Log('error', 'El servicio de costos esta apago.')
      return false
    end
  end

end