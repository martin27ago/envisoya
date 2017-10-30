class Loggermaster < ActiveRecord::Base
  def self.Log level, message
    file = File.new 'app.log', 'a'
    @logger = Logger.new file
    if level=='error'
      @logger.error(message)
    else
      @logger.info(message)
    end
  end
end