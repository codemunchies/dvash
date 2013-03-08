require 'dvash/honeypots/ipv6/base'

module Dvash
  module Honeypots
    module Ipv6
      
      class HTTP < Base
        
        def port
          80
        end
        
        Honeypot.register(self)
        
      end
      
    end
  end
end
