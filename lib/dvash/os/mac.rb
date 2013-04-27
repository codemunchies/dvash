module Dvash

	class Mac < Core

		def initialize
			#
			# Check to make sure we have binaries for ipfw using the paths
			# set in the configuration file
			#
			unless File.exist?(@@cfgfile['ipfw']['ipfw'])
				# TODO: Use 'logger' gem to output debug information
				puts "can't find ipfw"
				exit
			end
		end

		def block_ip(address)
			#
			# Block the client IP address using ipfw binaries set in the configuration file
			#
			system("#{@@cfgfile['ipfw']['ipfw']} -q add deny src-ip #{address}")
		end

	end
end