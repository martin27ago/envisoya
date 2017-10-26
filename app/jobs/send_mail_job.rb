class SendMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "hola"
  end
end
