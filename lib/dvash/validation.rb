require 'ipaddr'
require 'securerandom'

module Dvash

	class Validation

		def valid_user?
			Process.uid == 0
		end

		def valid_ip?(address)
			begin
				IPAddr.new("#{address}")
				true
			rescue
				false
			end
		end

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
				puts "invalid operating system" # replace me
	      exit
			end
		end

		def load_conf
			begin
				@@cfgfile = ParseConfig.new(@paths[:config_path])
			rescue
				puts "invalid configuration file" # replace me
				exit
			end
		end

		def load_honeyport
			@@cfgfile['honeyports'].each do |key, value|
				if value == 'true' then
					ipver, proto = key.split("_")
					require "dvash/honeyports/#{ipver}/#{proto}"
					@honey_threads << Thread.new { Dvash::Honeyport.new.send(key) }
				end
			end
		end

		def random_data
			SecureRandom.random_bytes(64)
		end

		def client_ip(client)
			client.peeraddr[3]
		end

	end
end