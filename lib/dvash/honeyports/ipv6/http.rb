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
	#
	# Main Honeyport class to simulate daemons
	#
	class Honeyport < Core

		def ipv6_http
			# IPv6 TCPServer object
			# @return [TCPServer] tcp/80 HTTPd
			server = TCPServer.new('::', 80)
			# Infinite listening loop
			loop do
				# Fork a new instance of [TCPServer] when a client connects
				# TODO: Maybe we should not send junk data until after the client IP 
				# has been validated	
			    Thread.fork(server.accept) do |client| 
			        # Send the connected client junk data
			        client.puts(random_data)
			        # Make sure the client has a valid IP address
			        # @return [Boolean] true|false
			        if valid_ip?(client_ip(client)) then 
			        	# Block the IP address
			        	@@os.block_ip(client_ip(client))
			        end
			        # Close the connection to the client and kill the forked process
			        client.close
			    end
			end
		end

	end
end