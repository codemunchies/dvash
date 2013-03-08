#!/usr/bin/env ruby
###############################################################################
#
#  Dvash Defense - SSHd Module
#  version 0.01a
#
#  Written By: Ari Mizrahi
#
#  Module to simulate sshd server
#
###############################################################################

def start_httpd()
	server = TCPServer.new(22)
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