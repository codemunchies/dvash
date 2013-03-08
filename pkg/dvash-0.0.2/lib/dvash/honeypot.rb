require 'securerandom'
require 'socket'
require 'ipaddr'

require 'dvash/application'

module Dvash
  
  # The base class for Dvash honeypots.
  class Honeypot < Service
    
    class << self
      
      def register(honeypot)
        raise InvalidHoneypot unless honeypot.is_a?(Honeypot)
        registered_honeypots << honeypot
      end
      
      def registered_honeypots
        @registered_honeypots ||= []
      end
      
    end
    
    def initialize(application)
      raise TypeError, '`application` must be a Dvash::Application' unless application.is_a?(Application)
      
      @application = application
    end
    
    # @abstract Subclass and override {#host} to implement a custom Honeypot class.
    def host
      raise NotImplementedError
    end
    
    # @abstract Subclass and override {#port} to implement a custom Honeypot class.
    def port
      raise NotImplementedError
    end
    
    # @return [TCPServer] The instance of TCPServer that we are using as a honeypot.
    def server
      @server ||= TCPServer.new(host, port)
    end
    
    # The block to call within the run-loop.
    # Waits for a client to connect to the {#server} and when it does,
    # calls {#respond}, passing the client as a argument, in a new Thread.
    def execute
      Thread.fork(server.accept, &respond)
    end
    
    protected
    
    # Log a message to the application's logger
    def log(message, level=:info)
      message = "#{self.class} - #{message}"
      
      @application.logger.send(level, message) if @application.logging?
    end
    
    # @return [String] A random string of junk data to send to clients which connect to the honeypot
    def random_string
      SecureRandom.random_bytes
    end
    
    # @return [true, false] Does the client have a valid IP address?
    def client_has_valid_ip?(client)
      ip = client_ip(client)
      
      begin
        IPAddr.new(ip)
        log "IP '#{ip}` is valid"
        
        true
      rescue
        log "IP '#{ip}` is invalid", :error
        
        false
      end
    end
    
    # @param [TCPSocket] client The client
    # @return [String] The client's IP address.
    def client_ip(client)
      client.peeraddr[3].to_s
    end
    
    # Block a client.
    # @param [TCPSocket] client The client
    def block(client)
      ip = client_ip(client)
      
    	if ip.ipv4?
        system("#{@application.config['iptables']['ipv4']} -I DVASH -s #{ip} -j DROP")
        log "IPv4 address #{ip} was blocked"
      elsif ip.ipv6?
        system("#{@application.config['iptables']['ipv6']} -I DVASH -s #{ip} -j DROP")
        log "IPv6 address #{ip} was blocked"
    	end
    end
    
    # Respond to the client.
    def respond(client)
      client.puts(random_string) # Send the client junk data
      block(client) if client_has_valid_ip?(client)
      client.close
    end
    
  end
  
end
