#!/usr/bin/env ruby
###############################################################################
#
#  Core Libraries
#  version 0.01a
#
#  Written By: Ari Mizrahi
#
#  Core libraries for Dvash Defense
#
###############################################################################

def write_log(message, path = './log')
	# create the log path if it doesn't exist
	Dir.mkdir('log') unless Dir.exists?('log')
	if @debug then puts 'DEBUG: created log dir' end
	
	# open the logfile for appending using today's date as filename
	logfile = File.open("#{path}/#{Time.now.strftime("%Y%m%d")}.log", 'a')
	if @debug then puts 'DEBUG: log file created' end

	# write a message to the logfile
	logfile.puts "#{Time.now.strftime("%H:%M:%S %z")},#{message}"
	if @debug then puts 'DEBUG: wrote a message in the logfile' end
end

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
