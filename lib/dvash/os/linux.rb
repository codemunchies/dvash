module Dvash

	class Linux

		def initialize
			unless File.exist?(@@cfgfile['iptables']['ipv4'])
				puts "can't find iptables"
				exit
			end

			# do not create if it has already been created
			unless `"#{@@cfgfile['iptables']['ipv4']}" -L INPUT`.include?('DVASH')
				# create a new chain
				system("#{@cfgfile['iptables']['ipv4']} -N DVASH")
				# flush the new chain
				system("#{@cfgfile['iptables']['ipv4']} -F DVASH")
				# associate new chain to INPUT chain
				system("#{@cfgfile['iptables']['ipv4']} -I INPUT -j DVASH")
			end

			# do not create if it has already been created
			unless `"#{@@cfgfile['iptables']['ipv6']}" -L INPUT`.include?('DVASH')
				# create a new chain
				system("#{@cfgfile['iptables']['ipv6']} -N DVASH")
				# flush the new chain
				system("#{@cfgfile['iptables']['ipv6']} -F DVASH")
				# associate new chain to INPUT chain
				system("#{@cfgfile['iptables']['ipv6']} -I INPUT -j DVASH")
			end
		end

		def block_ip(address)

			if IPAddr.new("#{address}").ipv4? then
				system("#{@cfgfile['iptables']['ipv4']} -I DVASH -s #{badip} -j DROP")
			end

			if IPAddr.new("#{address}").ipv6? then
				system("#{@cfgfile['iptables']['ipv6']} -I DVASH -s #{badip} -j DROP")
			end
		end

	end
end