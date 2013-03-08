require 'dvash/application'

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
  
  # Start a new application with logging to a terminal and a file.
  def self.start(options={})
    raise TypeError, '`options` must be a Hash or respond to :to_hash or :to_h' unless options.is_a?(Hash) || options.respond_to?(:to_hash) || options.respond_to?(:to_h)
    options = options.to_hash rescue options.to_h unless options.is_a?(Hash)
    
    options = {
      config_path: '/etc/dvash.conf',
      log_path: '/var/log/dvash.log',
    }.merge(options)
    
    options[:config_path] = Pathname.new( options[:config_path] )
    
    application = Application.new( options[:config_path] )
    
    unless options[:log_path].nil?
      options[:log_path] = Pathname.new( options[:log_path] ).expand_path
      options[:log_path].dirname.mkpath # Recursively create the parent directories of the log_path, if they don't already exist
      application.log_output.targets << options[:log_path].open('a')
    end
    
    begin
      application.start
    rescue => error
      application.logger.error(error)
        
      exit
    end
  end
  
end
