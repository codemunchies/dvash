#!/usr/bin/env ruby
###############################################################################
#
#  Logging Libraries
#  version 0.01a
#
#  Written By: Ari Mizrahi
#
#  Logging libraries for Dvash Defense
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

def write_blacklist

end

def read_whitelist

end