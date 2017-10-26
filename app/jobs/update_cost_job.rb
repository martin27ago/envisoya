class UpdateCostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "holaupdate"
    Costzone.UpdateCostZones
    Cost.UpdateCost
  end
end
