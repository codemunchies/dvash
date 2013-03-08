module Dvash
  
  # The base class for Dvash error classes.
  class Error < StandardError; end
  
  # The base class for Dvash error classes dealing with the config file.
  class ConfigFileError < Error
    
    # @param [String] config_file The path of the Dvash config file.
    def initialize(config_file)
      @config_file = config_file
    end
    
  end
  
  # Raised when the config file for Dvash does not exist.
  class NoConfigFileError < ConfigFileError
    
    # @return [String] The error message.
    def to_s
      "File `#{@config_file}` does not exist"
    end
    
  end
  
  # Raised when the config file for Dvash is invalid.
  class InvalidConfigFileError < ConfigFileError
    
    # @return [String] The error message.
    def to_s
      "File `#{@config_file}` is invalid"
    end
    
  end
  
  # Raised when the current system's OS is not *NIX based.
  class InvalidOperatingSystemError < Error
    
    # @return [String] The error message.
    def to_s
      'The current system must be running on a *NIX based operating system'
    end
    
  end
  
  # Raised when the process is not being run as the `root` user.
  class InvalidUserError < Error
    
    # @return [String] The error message.
    def to_s
      'The process must be run as root'
    end
    
  end
  
  # Raised when the ipv4tables config file does not exist.
  class InvalidIpv4tablesError < Error
    
    # @return [String] The error message.
    def to_s
      "No ipv6tables found, we can't block IPv4 addresses!"
    end
    
  end
  
  # Raised when the ipv6tables config file does not exist.
  class InvalidIpv6tablesError < Error
    
    # @return [String] The error message.
    def to_s
      "No ipv6tables found, we can't block IPv4 addresses!"
    end
    
  end
  
end