module Dvash
  #
  # Used by Mac OS X systems to leverage ipfw for blocking all of the peoples
  #
  class Mac < Core

    def initialize
      # Make sure we have binaries for ipfw using the paths
      # set in the configuration file
      unless File.exist?(@@cfgfile['ipfw']['ipfw'])
        # TODO: Use [logger] gem to output debug information
        puts "can't find ipfw"
        exit
      end
    end

    def block_ip(address)
      # Block the client IP address using ipfw binaries set in the conf file
      if IPAddr.new("#{address}").ipv4? then
        system("#{@@cfgfile['ipfw']['ipfw']} -q add deny all from #{address} to any")
      end

      # Block the client IP address using ip6fw binaries set in the conf file
      if IPAddr.new("#{address}").ipv6? then
        system("#{@@cfgfile['ipfw']['ip6fw']} -q add deny all from #{address} to any")
      end
    end

  end
end