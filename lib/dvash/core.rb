require 'ipaddr'
require 'securerandom'

module Dvash
	#
	# Core class contains methods all other classes depend on to function properly.
	#
	class Core

		# Validates user
		# We must be root to create entries in the firewall
		# @return [Boolean] true|false
		def valid_user?
			Process.uid == 0
		end

		# Validates an IP address
		# IP Address should be valid IPv4 or IPv6 addresses
		# @return [Boolean] true|false
		def valid_ip?(address)
			begin
				IPAddr.new("#{address}")
				true
			rescue
				false
			end
		end

		# Validates the operating system
		# OS must be Windows 7+, OS X, or Linux
		# Creates a new instance of the operating system specific Dvash libraries 
		# required to block IP addresses properly, @@os is used as a class variable 
		# to call its methods from within a Honeyport
		def validate_os
			# Rubygems platform data
			system = RUBY_PLATFORM
			# Use regular expressions to determine operating system
			case system
			# WINDOWS
			when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
				# Create Dvash Windows object for use within 'honeyports' modules
				require 'dvash/os/windows'
	      		@@os = Dvash::Windows.new
	    	# MAC OS X
			when /darwin|mac os/
				# Create Dvash Mac OS X object for use within 'honeyports' modules
				require 'dvash/os/mac'
	      		@@os = Dvash::Mac.new
	    	# LINUX
			when /linux/
				# Create Dvash Linux object for use within 'honeyports' modules
				require 'dvash/os/linux'
	      		@@os = Dvash::Linux.new
	    	# BSD
			when /solaris|bsd/
				# TODO: BSD support
				exit
			else
				# TODO: Use [logger] gem to output debug information
				puts "invalid operating system"
	      		exit
			end
		end

		# Loads the configuration file using [ParseConfig]
		def load_conf
			begin
				@@cfgfile = ParseConfig.new(@paths[:config_path])
			rescue
				# TODO: Use 'logger' gem to output debug information
				puts "invalid configuration file"
				exit
			end
		end

		# Load all Honeyports set true in the configuration file
		def load_honeyport
			# Read honeyports group in configuration file, parse keys and values
			@@cfgfile['honeyports'].each do |key, value|
				if value == 'true' then
					ipver, proto = key.split("_")
					# Load methods for all honeyports set true
					begin
						require "dvash/honeyports/#{ipver}/#{proto}"
					rescue
						# TODO: Use [logger] gem to output debug information
						puts "couldn't load dvash/honeyports/#{ipver}/#{proto}"
						exit
					end
					# Push the loaded honeyport into a thread
					@honey_threads << Thread.new { Dvash::Honeyport.new.send(key) }
				end
			end
		end

		# Generate a random string 64 bytes long
		# @return [String] random bytes
		def random_data
			SecureRandom.random_bytes(64)
		end

		# Client source IP address in a [TCPServer]
		# @return [String] client IP
		def client_ip(client)
			client.peeraddr[3]
		end

	end
end