class SendMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Start Shipping"
    Shipping.DeliveredShipping
    Shipping.ConfirmPrice
    puts "Finally Shipping"
  end
end
