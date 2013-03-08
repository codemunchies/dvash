require 'dvash/honeypot'

module Dvash
  module Honeypots
    module Ipv4
      
      class Base < Honeypot
        
        def host
          '127.0.0.1'
        end
        
      end
      
    end
  end
  
end
