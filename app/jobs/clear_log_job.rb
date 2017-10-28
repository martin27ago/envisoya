class ClearLogJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Start clear log"
    File.delete('logFile') if File.exist?('logFile')
    puts "Finally clear log"
  end
end
