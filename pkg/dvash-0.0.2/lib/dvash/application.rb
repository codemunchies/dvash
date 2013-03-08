require 'pathname'
require 'parseconfig'
require 'system/os'

require 'dvash/errors'
require 'dvash/banner'
require 'dvash/logging'

module Dvash
  
  # The Dvash application.
  class Application
  
    include Logging
    
    attr_reader :honeypots, :config
    
    # @param [String] config_file The path of the Dvash config file.
    def initialize(config_file)
      validate_process
      setup_config_file(config_file)
      validate_config
      setup_iptables
    rescue Dvash::NoConfigFileError => error
      logger.error(error.to_s)
      
      generate_config_file(error.config_file)
    rescue Dvash::Error => error
      logger.error(error.to_s)
        
      exit
    end
    
    # Start the Dvash application.
    def start
      display_banner if STDOUT.tty?
      load_honeypots
      start_honeypots
    end
  
    protected
    
    # Generate the config file.
    def generate_config_file(config_file)
      config_file = Pathname.new(config_file).expand_path
      logger.info "Generating config at `#{config_file}`"

      config_file.dirname.mkpath
      default_config_file = Pathname.new(__FILE__).join('..', '..', '..', 'config', 'dvash.conf').expand_path
      config_file.open('w+') { |file| file.puts(default_config_file.read) }

      setup_config_file(config_file)
    rescue => error
      logger.error(error.to_s)
        
      exit
    end
    
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
    
    # Run all process validations.
    # @return [true, false] Were all validations run successfully?
    def validate_process
      raise InvalidOperatingSystemError unless valid_os?
      raise InvalidUserError            unless valid_user?
      
      true
    end

    
    # Run all config validations.
    # @return [true, false] Were all validations run successfully?
    def validate_config
      # TODO: Must have one or both enabled. Fail if both are disabled.
      raise InvalidIpv4tablesError      unless valid_ipv4tables?
      raise InvalidIpv6tablesError      unless valid_ipv6tables?
      
      true
    end
    
    def setup_iptables
      # TODO
    end
    
    # def prepare_iptables
    #   if @ipv4tables then
    #     # do not create if it has already been created
    #     if `"#{@cfgfile['iptables']['ipv4']}" -L INPUT`.include?('DVASH') then
    #       if @debug then puts "DEBUG: DVASH IPv4 chain already created!" end
    #       if @log then write_log('INFO,dvash ipv4 chain already created skipping prepare') end
    #       return false
    #     end
    #     # create a new chain
    #     system("#{@cfgfile['iptables']['ipv4']} -N DVASH")
    #     # flush the new chain
    #     system("#{@cfgfile['iptables']['ipv4']} -F DVASH")
    #     # associate new chain to INPUT chain
    #     system("#{@cfgfile['iptables']['ipv4']} -I INPUT -j DVASH")
    #     if @debug then puts "DEBUG: iptables ready for blocking!" end
    #     if @log then write_log('INFO,iptables prepared for blocking') end
    #   end
    # end
    # 
    # def prepare_ip6tables
    #   if @ipv6tables then
    #     # do not create if it has already been created
    #     if `"#{@cfgfile['iptables']['ipv6']}" -L INPUT`.include?('DVASH') then
    #       if @debug then puts "DEBUG: DVASH IPv6 chain already created!" end
    #       if @log then write_log('INFO,dvash ipv6 chain already created skipping prepare') end
    #       return false
    #     end
    #     # create a new chain
    #     system("#{@cfgfile['iptables']['ipv6']} -N DVASH")
    #     # flush the new chain
    #     system("#{@cfgfile['iptables']['ipv6']} -F DVASH")
    #     # associate new chain to INPUT chain
    #     system("#{@cfgfile['iptables']['ipv6']} -I INPUT -j DVASH")
    #     if @debug then puts "DEBUG: ip6tables ready for blocking!" end
    #     if @log then write_log('INFO,ip6tables prepared for blocking') end
    #   end
    # end
    
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
