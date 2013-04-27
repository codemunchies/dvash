require 'dvash/core'

require 'parseconfig'

module Dvash

	class Application < Core

		#
		# Methods that should run when the Dvash Application object is created
		# Requires one argument of type Array including paths to configuration
		# file and destination for log file
		#
		def initialize(paths)
			#
			# Create @honey_threads Array to hold all 'honeyport' threads
			#
			@honey_threads = Array.new
			#
			# Load passed Array paths into @paths for use in the class
			#
			@paths = paths
			#
			# Call method to load the configuration file
			#
			load_conf
			#
			# Call method to validate the operating system and load necessary Dvash methods
			#
			validate_os
		end

		#
		# Fire in the hole!
		#
		def start
			#
			# Make sure we are running with elevated privileges
			#
			unless valid_user?
				# TODO: Use 'logger' gem to output debug information
				puts "invalid user"
				exit
			end

			#
			# Call method to load all 'honeyports' set as 'true' in the configuration file
			#
			load_honeyport
			#
			# Start all loaded threads
			#
			@honey_threads.each { |thr| thr.join }
		end

	end
end