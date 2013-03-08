#!/usr/bin/env ruby
###############################################################################
#
#  Sanity Libraries
#  version 1.0
#
#  Written By: Ari Mizrahi
#
#  Sanity checks libraries for Dvash Defense
#
###############################################################################

def check_os
	# make sure we are running on a linux based os
	Process.exit unless RUBY_PLATFORM.include?("linux")
	if @debug then puts 'DEBUG: os checks out' end
	if @log then write_log('INFO,os checks out') end
end

def check_uid
	# make sure we are running as root
	if Process.uid == 0 then
		if @debug then puts "DEBUG: we are root" end
		if @log then write_log('INFO,dvash running as root') end
	else
		# send a message if we are not root
		puts "CRITICAL: you must run dvash as root".red
		if @log then write_log("CRITICAL,dvash was run with uid #{Process.uid} and exit") end
		Process.exit
	end
end

def check_iptables
	# check for iptables binary
	@ipv4tables = true if File.exist?(@cfgfile['iptables']['ipv4'])
	# for debug
	if @debug and @ipv4tables then 
		puts "DEBUG: found iptables!"
	elsif @debug
		puts "DEBUG: no iptables found, we can't block IPv4 addresses!"
	end
	# for logging
	if @log and @ipv4tables then
		write_log('INFO,iptables is available on this system')
	elsif @log
		write_log('INFO,no iptables found block_ip disabled for ipv4')
	end
	
	# check for ip6tables binary
	@ipv6tables = true if File.exist?(@cfgfile['iptables']['ipv6'])
	#for debug
	if @debug and @ipv6tables then 
		puts "DEBUG: found ip6tables!"
	elsif @debug
		puts "DEBUG: no ip6tables found, we can't ban IPv6 addresses!"
	end
	#for logging
	if @log and @ipv6tables then
		write_log('INFO,ip6tables is available on this system')
	elsif @log
		write_log('INFO,no ip6tables found block_ip disabled for ipv6')
	end
end