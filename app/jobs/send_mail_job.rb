class SendMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Start Shipping"
    Shipping.delivered_shipping
    Shipping.confirm_price
    puts "Finally Shipping"
  end
end
