require 'dvash/honeypots/ipv4/base'

module Dvash
  module Honeypots
    module Ipv4
      
      class HTTP < Base
        
        def port
          80
        end
        
        Honeypot.register(self)
        
      end
      
    end
  end
end
