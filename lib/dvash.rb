require 'dvash/application'

require 'optparse'

#
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
#

module Dvash
  
  def self.start(paths={})

    #
    # Set default path to config and log files
    # TODO: These settings assume Linux default paths, should determine the operating system then configure accordingly
    #
    paths[:config_path] = '/etc/dvash.conf'
    paths[:log_path] = '/var/log/dvash.conf'
    
    #
    # A command-line interface using OptionParser
    #
    OptionParser.new do |opts|
      opts.banner = "Dvash 0.0.6 ( http://www.github.com/codemunchies/dvash )\n"
      opts.banner += "Usage: dvash [options]"
      #
      # Option to set an alternate configuration file
      #
      opts.on("--config-file [PATH]", "Set path to config file") do |arg|
        paths[:config_path] = arg
      end
      #
      # Option to set an alternate log file destination and filename
      #
      opts.on("--log-file [PATH]", "Set path to log file") do |arg|
        paths[:log_path] = arg
      end
    end.parse!

    #
    # Create and start an Application instance
    #
    begin
      application = Dvash::Application.new(paths)
      application.start
    rescue
      # TODO: Use 'logger' gem to output debug information
      puts "couldn't start application"
      exit
    end


  end
end