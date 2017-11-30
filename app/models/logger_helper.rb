require 'uri'
require 'net/http'
class LoggerHelper < ActiveRecord::Base
  def self.Log level, message
    begin
      url = URI(ENV['URLLogger'])

      http = Net::HTTP.new(url.host, url.port)
      if Rails.env.production?
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Post.new(url, {'Content-Type' => 'application/json'})
      request.body = {:level => level, :description => message}.to_json

      http.request(request)
    rescue
      file = File.new 'app.log', 'a'
      @logger = Logger.new file
      if level=='error'
        @logger.error(message)
      else
        @logger.info(message)
      end
    end
  end
end