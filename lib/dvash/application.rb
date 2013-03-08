require 'pathname'
require 'parseconfig'
require 'system/os'

require 'dvash/errors'
require 'dvash/banner'
require 'dvash/logging'

module Dvash
  
  # The Dvash application.
  class Application
  
    extend Logging
    
    attr_reader :honeypots, :config
    
    # @param [String] config_file The path of the Dvash config file.
    def initialize(config_file)
      setup_config_file(config_file)
    end
    
    # Start the Dvash application.
    def start
      display_banner if STDOUT.tty?
      validate
      load_honeypots
      start_honeypots
    end
  
    protected
    
    # Parse and validate the config file.
    # @return [ParseConfig] The parsed config file.
    def setup_config_file(config_file)
      config_file = Pathname.new(config_file).expand_path
    
      raise NoConfigFileError, config_file unless config_file.exist?
    
      begin
        @config = ParseConfig.new(config_file)
        @config['iptables']['ipv4'] = Pathname.new( @config['iptables']['ipv4'] ) unless @config['iptables'].nil? && @config['iptables']['ipv4'].nil?
        @config['iptables']['ipv6'] = Pathname.new( @config['iptables']['ipv6'] ) unless @config['iptables'].nil? && @config['iptables']['ipv6'].nil?
        
        @config
      rescue
        raise InvalidConfigFileError, config_file
      end
    end
    
    # Display a random banner for Dvash, for fun.
    def display_banner
      puts Banner.random
    end
    
    # Run all validations.
    # @return [true, false] Were all validations run successfully?
    def validate
      raise InvalidOperatingSystemError unless valid_os?
      raise InvalidUserError            unless valid_user?
      raise InvalidIpv4tablesError      unless valid_ipv4tables?
      raise InvalidIpv6tablesError      unless valid_ipv6tables?
      
      true
    end
    
    # Load all honeypots in the config.
    # @return [true, false] Were all honeypots loaded?
    def load_honeypots
      begin
    	  @config['honeypots'].each do |key, value|
    	  	if value == 'true' then
            ip_version, name = key.split('_')
    	  		require "dvash/honeypots/#{ip_version}/#{name}"
    	  	end
    	  end
        
        true
      rescue
        false
      end
    end
    
    # Start all registered honeypots in new Threads.
    # @return [<Honeypot>] An Array containing all instances of Honeypot started by this Application.
    def start_honeypots
      @honeypots = Honeypot.registered_honeypots.collect(&:new)
      @honeypots.each(&:start!)
      
      @honeypots
    end
    
    # @return [true, false] Is the current system running on a *NIX based OS?
    def valid_os?
      [:linux, :bsd, :osx, :darwin].include?(System::OS.name)
    end
  
    # @return [true, false] Is the current user root?
    def valid_user?
      Process.uid == 0
    end
  
    # @return [true, false] Does the ipv4tables config file exist?
    def valid_ipv4tables?
      @config['iptables']['ipv4'].exist?
    end
  
    # @return [true, false] Does the ipv6tables config file exist?
    def valid_ipv6tables?
      @config['iptables']['ipv6'].exist?
    end
  
  end
  
end
