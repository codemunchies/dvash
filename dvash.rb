#!/usr/bin/env ruby
###############################################################################
#
#  Dvash Defense
#  version 0.01a
#
#  Written By: Ari Mizrahi
#
#  Part honeypot, part defense system.  Opens up ports and simulates services
#  in order to look like an attractive target.  Hosts that try to connect to
#  the fake services are considered attackers and blocked from all access.
#  
#  Heavily inspired by The Artillery Project by Dave Kennedy (ReL1K) with a
#  passion for ruby and a thirst for knowledge.
#
###############################################################################

require 'socket'
require 'ipaddr'
require 'parseconfig'
require './lib/core.rb'
require './lib/sanity.rb'
require './lib/log.rb'
require './lib/colorize.rb'
require './lib/banner.rb'

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
