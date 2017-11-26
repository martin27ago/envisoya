require 'uri'
require 'net/http'
class LoggerHelper < ActiveRecord::Base
  def self.Log level, message

    url = URI(ENV['URLLogger'])

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url, {'Content-Type' => 'application/json'})
    request.body = {:level => level, :description => message}.to_json

    response = http.request(request)

  end
end