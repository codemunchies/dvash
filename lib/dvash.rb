require 'socket'
require 'ipaddr'

require './lib/core.rb'
require './lib/sanity.rb'
require './lib/log.rb'
require './lib/colorize.rb'
require './lib/banner.rb'

require 'system/os'



require 'dvash/application'

# Dvash Defense
# 
# Written By: Ari Mizrahi
# 
# Part honeypot, part defense system.  Opens up ports and simulates services
# in order to look like an attractive target.  Hosts that try to connect to
# the fake services are considered attackers and blocked from all access.
# 
# Heavily inspired by The Artillery Project by Dave Kennedy (ReL1K) with a
# passion for ruby and a thirst for knowledge.
module Dvash
  
  # Start a new application with logging to a terminal and a file.
  def self.start(log_path='/var/log/dvash.log')
  
end

__END__

# set run levels
@debug = false
@log = false
@ipv4tables = false
@ipv6tables = false
# bucket for module threads
@module_threads = []
# load conf file
load_conf
# start health checks
check_os
check_uid

check_iptables

# prepare iptables for blocking
prepare_iptables
prepare_ip6tables
# fun
display_banner
# load all enabled modules
load_modules
# start up all the loaded modules
@module_threads.each { |thr| thr.join }
if @log then write_log('INFO,Dvash Started Successfully') end



#!/usr/bin/env ruby
###############################################################################
#
#  Core Libraries
#  version 1.1
#
#  Written By: Ari Mizrahi
#
#  Core libraries for Dvash Defense
#
###############################################################################

def random_string
	# generate a bucket of chars for randomization
	bucket =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
	 # pick random chars from the bucket and return a 255 char string
	return (0...255).map{ bucket[rand(bucket.length)] }.join
end

def load_conf
	# load the config file
	begin
		@cfgfile = ParseConfig.new('./etc/dvash.conf')
		if @debug then puts 'DEBUG: loaded conf file' end
		if @log then write_log('INFO,dvash config file loaded') end
	rescue
		puts "CRITICAL: couldn't find dvash.conf!".red
		if @log then write_log('CRITICAL,dvash config file missing and exit') end
		Process.exit
	end
end

def load_modules
	# loop through Modules group and find enabled Modules
	@cfgfile['modules'].each do |key, value|
		if value == "true" then
			# load the required module from lib
			require "./mod/#{key}.rb"
			# push the module into the thread bucket
			@module_threads << Thread.new { send("start_#{key}") }
			if @debug then puts "DEBUG: loaded #{key} module into thread bucket" end
			if @log then write_log("INFO,successfully loaded #{key} module") end
		end
	end
end

def validate_ip(address)
	# no need to reinvent the wheel, self-explanatory
	begin
		if IPAddr.new("#{address}") then
			if @debug then puts "DEBUG: #{address} is valid!" end
			if @log then write_log("INFO,#{address} was validated") end
			return true
		end
	rescue
		if @debug then puts "DEBUG: #{address} is invalid!" end
		if @log then write_log("CRITICAL,#{address} was invalid and was not processed") end
		return false
	end
end

def block_ip(address)
	badip = IPAddr.new("#{address}")
	
	# ban ipv4 address
	if badip.ipv4? and @ipv4tables then
		system("#{@cfgfile['iptables']['ipv4']} -I DVASH -s #{badip} -j DROP")
		if @debug then puts "DEBUG: IPv4 address #{badip} blocked!" end
		if @log then write_log("BLOCKED,IPv4 address #{badip} was blocked") end
		# write to blocklist.log
	end

	# ban ipv6 address
	if badip.ipv6? and @ipv6tables then
		system("#{@cfgfile['iptables']['ipv6']} -I DVASH -s #{badip} -j DROP")
		if @debug then puts "DEBUG: IPv6 address #{badip} blocked!" end
		if @log then write_log("BLOCKED,IPv6 address #{badip} was blocked") end
		# write to blocklist.log
	end
end

def prepare_iptables
	if @ipv4tables then
		# do not create if it has already been created
		if `"#{@cfgfile['iptables']['ipv4']}" -L INPUT`.include?('DVASH') then
			if @debug then puts "DEBUG: DVASH IPv4 chain already created!" end
			if @log then write_log('INFO,dvash ipv4 chain already created skipping prepare') end
			return false
		end
		# create a new chain
		system("#{@cfgfile['iptables']['ipv4']} -N DVASH")
		# flush the new chain
		system("#{@cfgfile['iptables']['ipv4']} -F DVASH")
		# associate new chain to INPUT chain
		system("#{@cfgfile['iptables']['ipv4']} -I INPUT -j DVASH")
		if @debug then puts "DEBUG: iptables ready for blocking!" end
		if @log then write_log('INFO,iptables prepared for blocking') end
	end
end

def prepare_ip6tables
	if @ipv6tables then
		# do not create if it has already been created
		if `"#{@cfgfile['iptables']['ipv6']}" -L INPUT`.include?('DVASH') then
			if @debug then puts "DEBUG: DVASH IPv6 chain already created!" end
			if @log then write_log('INFO,dvash ipv6 chain already created skipping prepare') end
			return false
		end
		# create a new chain
		system("#{@cfgfile['iptables']['ipv6']} -N DVASH")
		# flush the new chain
		system("#{@cfgfile['iptables']['ipv6']} -F DVASH")
		# associate new chain to INPUT chain
		system("#{@cfgfile['iptables']['ipv6']} -I INPUT -j DVASH")
		if @debug then puts "DEBUG: ip6tables ready for blocking!" end
		if @log then write_log('INFO,ip6tables prepared for blocking') end
	end
end
