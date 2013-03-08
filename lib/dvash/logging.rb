require 'dvash/multi_io'

module Dvash
  
  # Methods for dealing with loggin within Dvash.
  module Logging
    
    # @return [Object] The current output for the logger.
    def log_output
      @log_output ||= MultiIO.new(STDOUT)
    end
    
    # @param [IO, String] output The new output IO or filename for the logger.
    # @return [Logger] The current logger output IO for Dvash.
    def log_output=(output)
      # A Logger's IO cannot be changed dynamically.
      # So, we just replace the current logger with one that directs to the new `log_output`
      @logger = Logger.new(output)
    end
    
    # @param [Logger::UNKNOWN, Logger::FATAL, Logger::ERROR, Logger::WARN, Logger::INFO, Logger::DEBUG] level The new level for the current logger.
    # @return [Logger::UNKNOWN, Logger::FATAL, Logger::ERROR, Logger::WARN, Logger::INFO, Logger::DEBUG] The new level for the current logger.
    def log_level=(level)
      logger.level = level
    end
    
    # @return [Logger] The current logger for Dvash.
    def logger
      @logger ||= Logger.new(log_output)
    end
    
    # @return [true, false] Is logging enabled?
    def logging?
      @logging_enabled
    end
    
    # @param [true, false, nil] value The truthy or falsey value to enable or diable logging.
    # @return [true, false] Is logging enabled?
    def logging_enabled=(value)
      @logging_enabled = !!value # "Bang-bang" or "not-not" turns any object into a boolean.
    end
    
    attr_reader :log_colors
    
    # @param [true, false, nil] value The truthy or falsey value to enable or diable log colors.
    # @return [true, false] Is log colors enabled?
    def log_colors=(value)
      @log_colors = !!value # "Bang-bang" or "not-not" turns any object into a boolean.
    end
    
  end
  
end