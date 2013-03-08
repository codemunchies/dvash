require 'pathname'
require 'parseconfig'

require 'dvash/errors'
require 'dvash/banner'
require 'dvash/logging'

module Dvash
  
  # The Dvash application.
  class Application
  
    extend Logging
    
    # @param [String] config_file The path of the Dvash config file.
    # @return [Dvash] The new and started instance of Dvash.
    def self.start(config_file)
      new(config_file).start
    end
  
    # @param [String] config_file The path of the Dvash config file.
    def initialize(config_file)
      # Note: Rubist's generally prefer .yaml over .conf files in their configs, but to each his own =)
      # Also, note that parseconfig has 7 open issues, most from about 8 months ago.. https://github.com/derks/ruby-parseconfig/issues
      # YAML is highly supported.
    
      # TODO: Define all settings in the config_file as accessors on Dvash.
      config_file = Pathname.new(config_file).expand_path
    
      raise NoConfigFileError, config_file unless config_file.exist?
    
      begin
        @config = ParseConfig.new(config_file)
        @config['iptables']['ipv4'] = Pathname.new( @config['iptables']['ipv4'] ) unless @config['iptables'].nil? && @config['iptables']['ipv4'].nil?
        @config['iptables']['ipv6'] = Pathname.new( @config['iptables']['ipv6'] ) unless @config['iptables'].nil? && @config['iptables']['ipv6'].nil?
      rescue # Note that "catch-all" rescue blocks are considered bad form.
        raise InvalidConfigFileError, config_file
      end
    end
  
    def start
      display_banner if STDOUT.tty?
      validate
    end
  
    protected
  
    def display_banner
      Banner.random
    end
  
    def validate
      raise InvalidOperatingSystemError unless valid_os?
      raise InvalidUserError            unless valid_user?
      raise InvalidIpv4tablesError      unless valid_ipv4tables?
      raise InvalidIpv6tablesError      unless valid_ipv6tables?
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
