require 'ipaddr'
require 'securerandom'

module Dvash

	class Core

		#
		# Validates user, must be root
		#
		def valid_user?
			Process.uid == 0
		end

		#
		# Validates an IP address, must be valid IPv4 or IPv6 address
		#
		def valid_ip?(address)
			begin
				IPAddr.new("#{address}")
				true
			rescue
				false
			end
		end

		#
		# Validates the operating system, must be windows, os x, or linux
		# Creates a new instance the operating system specific Dvash libraries required to block IP addresses properly
		# @@os is used as a class variable to call its methods from within a Honeyport
		#
		def validate_os
			system = RUBY_PLATFORM
			case system
			when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
				require 'dvash/os/windows'
	      @@os = Dvash::Windows.new
			when /darwin|mac os/
				require 'dvash/os/mac'
	      @@os = Dvash::Mac.new
			when /linux/
				require 'dvash/os/linux'
	      @@os = Dvash::Linux.new
			when /solaris|bsd/
				# TODO: BSD support
				exit
			else
				# TODO: Use 'logger' gem to output debug information
				puts "invalid operating system"
	      exit
			end
		end

		#
		# Loads the configuration file using ParseConfig
		#
		def load_conf
			begin
				@@cfgfile = ParseConfig.new(@paths[:config_path])
			rescue
				# TODO: Use 'logger' gem to output debug information
				puts "invalid configuration file"
				exit
			end
		end

		#
		# Load all Honeyports set 'true' in the configuration file
		# 
		def load_honeyport
			# 
			# Read 'honeyports' group in configuration file, parse keys and values
			#
			@@cfgfile['honeyports'].each do |key, value|
				if value == 'true' then
					ipver, proto = key.split("_")
					#
					# Load methods for all 'honeyports' set to 'true'
					#
					require "dvash/honeyports/#{ipver}/#{proto}"
					#
					# Push the loaded 'honeyport' into a thread
					#
					@honey_threads << Thread.new { Dvash::Honeyport.new.send(key) }
				end
			end
		end

		#
		# Return a string of random characters 64 bytes long
		#
		def random_data
			SecureRandom.random_bytes(64)
		end

		#
		# Return the client source IP address from a TCPServer object
		#
		def client_ip(client)
			client.peeraddr[3]
		end

	end
end