require 'dvash/honeypot'

module Dvash
  module Honeypots
    module Ipv6
      
      class Base < Honeypot
        
        def host
          '::'
        end
        
      end
      
    end
  end
end
