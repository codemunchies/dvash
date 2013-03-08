#!/usr/bin/env ruby
###############################################################################
#
#  Dvash Defense - Telnet Module
#  version 0.01a
#
#  Written By: Ari Mizrahi
#
#  Module to simulate telnet server
#
###############################################################################

def start_telnetd()
	server = TCPServer.new(21)
	loop do
	    Thread.fork(server.accept) do |client| 
	        # send the client junk data
	        client.puts(random_string)
	        # ban the address
	        if validate_ip("#{client.peeraddr[3]}") then
	        	block_ip("#{client.peeraddr[3]}")
	        end
	        if @debug then puts "#{client.peeraddr[3]} tried to talk to me!" end
	        client.close
	    end
	end
end