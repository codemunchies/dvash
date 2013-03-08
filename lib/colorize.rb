#!/usr/bin/env ruby
###############################################################################
#
#  Colorize Library
#  version 1.0
#
#  Written By: Ari Mizrahi
#
#  Extension of String class to include colors
#
###############################################################################

class String

	def red()
		return "\e[1;31;1m" + self + "\e[0m"
	end

	def green()
		return "\e[1;32;1m" + self + "\e[0m"
	end

	def yellow()
		return "\e[1;33;1m" + self + "\e[0m"
	end

	def blue()
		return "\e[1;34;1m" + self + "\e[0m"
	end

	def purple()
		return "\e[1;35;1m" + self + "\e[0m"
	end

	def cyan()
		return "\e[1;36;1m" + self + "\e[0m"
	end

end