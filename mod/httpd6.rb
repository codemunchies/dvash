#!/usr/bin/env ruby
###############################################################################
#
#  Dvash Defense - IPv6 HTTPd Module
#  version 1.0
#
#  Written By: Ari Mizrahi
#
#  Module to simulate an IPV6 httpd server
#
###############################################################################

def start_httpd6()
	server = TCPServer.new('::', 80)
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
