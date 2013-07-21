module Dvash
  #
  # Used by Linux systems to leverage IPTables for blocking all of the peoples
  #
  class Linux < Core

    def initialize
      # Make sure we have binaries for iptables using the paths
      # set in the configuration file
      unless File.exist?(@@cfgfile['iptables']['ipv4'])
        # TODO: Use [logger] gem to output debug information
        puts "can't find iptables"
        exit
      end
      # Do not create a new iptables chain if one already exists
      unless `"#{@@cfgfile['iptables']['ipv4']}" -L INPUT`.include?('DVASH')
        # Create a new DVASH chain
        system("#{@@cfgfile['iptables']['ipv4']} -N DVASH")
        # Flush the DVASH chain
        system("#{@@cfgfile['iptables']['ipv4']} -F DVASH")
        # Associate the DVASH chain to INPUT chain
        system("#{@@cfgfile['iptables']['ipv4']} -I INPUT -j DVASH")
      end
      # Do not create a new ip6tables chain if one already exists
      unless `"#{@@cfgfile['iptables']['ipv6']}" -L INPUT`.include?('DVASH')
        # Create a new DVASH chain
        system("#{@@cfgfile['iptables']['ipv6']} -N DVASH")
        # Flush the DVASH chain
        system("#{@@cfgfile['iptables']['ipv6']} -F DVASH")
        # Associate the DVASH chain to INPUT chain
        system("#{@@cfgfile['iptables']['ipv6']} -I INPUT -j DVASH")
      end
    end

    def block_ip(address)
      # Block the client IP address using iptables binaries set in the conf file
      if IPAddr.new("#{address}").ipv4? then
        system("#{@@cfgfile['iptables']['ipv4']} -I DVASH -s #{address} -j DROP")
      end

      # Block the client IP address using ip6tables binaries set in the conf file
      if IPAddr.new("#{address}").ipv6? then
        system("#{@@cfgfile['iptables']['ipv6']} -I DVASH -s #{address} -j DROP")
      end
    end

  end
end
