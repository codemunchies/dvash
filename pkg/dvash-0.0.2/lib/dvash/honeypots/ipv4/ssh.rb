require 'dvash/honeypots/ipv4/base'

module Dvash
  module Honeypots
    module Ipv4
      
      class SSH < Base
        
        def port
          22
        end
        
        Honeypot.register(self)
        
      end
      
    end
  end
end
