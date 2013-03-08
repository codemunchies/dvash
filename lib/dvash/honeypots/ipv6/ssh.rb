require 'dvash/honeypots/ipv6/base'

module Dvash
  module Honeypots
    module Ipv6
      
      class SSH < Base
        
        def port
          22
        end
        
        Honeypot.register(self)
        
      end
      
    end
  end
end
