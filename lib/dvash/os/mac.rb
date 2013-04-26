module Dvash

	class Mac < Validation

		def initialize
			unless File.exist?(@@cfgfile['ipfw']['ipfw'])
				puts "can't find ipfw"
				exit
			end
		end

		def block_ip(address)
			system("#{@@cfgfile['ipfw']['ipfw']} -q add deny src-ip #{address}")
		end

	end
end