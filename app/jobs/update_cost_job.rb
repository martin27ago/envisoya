require 'uri'
require 'net/http'
class UpdateCostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Start Update"
    Cost.UpdateCost
    Costzone.UpdateCostZones
    puts "Finally Update"
  end
end
