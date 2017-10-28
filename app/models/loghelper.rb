class Loghelper < ActiveRecord::Base
  def self.Log level, message
    file = File.new 'logFile', 'a'
    @logger = Logger.new file
    if level=='error'
      @logger.error(message)
    else
      @logger.info(message)
    end
  end
end
