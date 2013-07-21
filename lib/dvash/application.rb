require 'dvash/core'
require 'parseconfig'

module Dvash
  #
  # Main application methods, the glue that holds it all together
  #
  class Application < Core

    # Methods that should run when [Dvash] is created
    # @params [Hash] includes paths to config and log file
    def initialize(paths)
      # Instantiate @honey_threads [Array] to hold all honeyport threads
      @honey_threads = Array.new
      # Load passed [paths]
      @paths = paths
      # Load the configuration file
      load_conf
      # Validate the operating system and load necessary [Dvash] methods
      validate_os
    end

    # Fire in the hole!
    def start
      # Make sure we are running with elevated privileges
      unless valid_user?
        # TODO: Use [logger] gem to output debug information
        puts "invalid user"
        exit
      end
      # Load all honeyports set true in the configuration file
      load_honeyport
      # Start all loaded threads
      @honey_threads.each { |thr| thr.join }
      # Let the user know we're running
      puts "Dvash is running..."
    end

  end
end