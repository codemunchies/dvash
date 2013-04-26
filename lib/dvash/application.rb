require 'dvash/validation'

require 'parseconfig'

module Dvash

	class Application < Validation

		def initialize(paths)
			@honey_threads = Array.new
			@paths = paths

			load_conf
			validate_os
		end

		def start
			unless valid_user?
				puts "invalid user" # replace me
				exit
			end

			load_honeyport
			@honey_threads.each { |thr| thr.join }
		end

	end
end