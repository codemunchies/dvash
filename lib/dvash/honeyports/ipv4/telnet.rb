###############################################################################
#
#  Dvash Defense - Telnetd IPv4 Honeyport
#  version 1.0
#
#  Written By: Ari Mizrahi
#
#  Honeyport to simulate telnetd server
#
###############################################################################
module Dvash

	class Honeyport < Core

		def ipv4_telnet
			#
			# Create a new IPv4 TCPServer object
			#
			server = TCPServer.new(23)
			#
			# Infinite loop listens on port 23 pretending to be an Telnet server
			#
			loop do
					#
					# Fork a new instance of the TCPServer object when a client connects
					# TODO: Maybe we should not send junk data until after the client IP has been validated
					#	
			    Thread.fork(server.accept) do |client| 
			    		#
			        # Send the connected client junk data
			        #
			        client.puts(random_data)
			        #
			        # Make sure the client has a valid IP address
			        #
			        if valid_ip?(client_ip(client)) then 
			        	#
			        	# Block the IP address
			        	#
			        	@@os.block_ip(client_ip(client))
			        end
			        #
			        # Close the connection to the client and kill the forked process
			        #
			        client.close
			    end
			end
		end

	end
end