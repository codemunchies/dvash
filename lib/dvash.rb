require 'dvash/application'

require 'optparse'

# Dvash Defense
# 
# Written By: Ari Mizrahi
# 
# Part honeypot, part defense system.  Opens up ports and simulates services
# in order to look like an attractive target.  Hosts that try to connect to
# the fake services are considered attackers and blocked from all access.
# 
# Heavily inspired by The Artillery Project by Dave Kennedy (ReL1K) with a
# passion for ruby and a thirst for knowledge.

module Dvash
  
  # Start a new Dvash instance
  def self.start(paths={})

    # Set default options
    paths[:config_path] = '/etc/dvash.conf'
    paths[:log_path] = '/var/log/dvash.conf'
    
    # Command-line interface
    OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} [options]"

      opts.on("--config-file [PATH]", "Set path to config file") do |arg|
        paths[:config_path] = arg
      end

      opts.on("--log-file [PATH]", "Set path to log file") do |arg|
        paths[:log_path] = arg
      end
    end.parse!

    # Create and start an Application instance
    #begin
      application = Dvash::Application.new(paths)
      application.start
    #rescue
    #  puts "couldn't start application" # replace me
    #  exit
    #end


  end
end