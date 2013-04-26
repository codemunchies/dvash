###############################################################################
#
#  Dvash Defense - HTTPd IPv6 Honeyport
#  version 1.0
#
#  Written By: Ari Mizrahi
#
#  Honeyport to simulate httpd server
#
###############################################################################
module Dvash

	class Honeyport < Validation

		def ipv4_http
			server = TCPServer.new('::', 80)
			loop do
			    Thread.fork(server.accept) do |client| 
			        # send the client junk data
			        client.puts(random_data)
			        @@os.block_ip(client_ip(client))
			        client.close
			    end
			end
		end

	end
end