module Dvash
	
	class Windows < Validation

		def block_ip(address)

			# win7+ compatible, easier to blackhole the IP
			system("route add #{address} mask 255.255.255.255 10.255.255.255 if 1 -p")
		end

	end
end