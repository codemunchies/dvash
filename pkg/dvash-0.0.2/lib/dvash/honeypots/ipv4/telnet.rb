require 'dvash/honeypots/ipv4/base'

module Dvash
  module Honeypots
    module Ipv4
      
      class Telnet < Base
        
        def port
          21
        end
        
        Honeypot.register(self)
        
      end
      
    end
  end
end
