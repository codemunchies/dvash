module Dvash
	
	class Windows < Core

		def block_ip(address)
			#
			# Windows 7 and newer compatible
			# Blackholes the client IP address by sending traffic to a non-existing gateway
			#
			system("route add #{address} mask 255.255.255.255 10.255.255.255 if 1 -p")
		end

	end
end