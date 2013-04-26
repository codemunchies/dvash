module Dvash

	class Mac < Validation

		def block_ip(address)
			system("#{@@cfgfile['ipfw']['ipfw']} -q add deny src-ip #{address}")
		end

	end
end