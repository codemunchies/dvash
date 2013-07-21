module Dvash
	#
	# Used by Windows systems to leverage route command for blocking all of the peoples
	#
	class Windows < Core

		def block_ip(address)
			# Windows XP/Server 2003 compatible but we don't have a way to determine
			# what version of Windows is running, so we assume the newer versions
			# we're going to leave this here for now in case sometime in the future
			# we can figure out how to determine the differenc between WinXP/2003 and Win7
			#
			# system("route add #{address} mask 255.255.255.255 10.255.255.255 metric 1 -p")

			# Windows 7/Server 2008 and newer compatible (IPv4)
			# Blackholes the client IP address by routing traffic to a null route
			if IPAddr.new("#{address}").ipv4? then
				system("route add #{address} mask 255.255.255.255 10.255.255.255 if 1 -p")
			end

			# Windows 7/Server 2008 and newer compatible (IPv6)
			# Blackholes the client IP address by routing traffic to localhost
			if IPAddr.new("#{address}").ipv6? then
				system("netsh interface ipv6 add route #{address} \"Local Area Connection\" ::1")
			end
		end

	end
end