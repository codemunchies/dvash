module Dvash
  
  # An IO "proxy" that writes to multiple IO instances.
  class MultiIO
    
    attr_accessor :targets
    
    def initialize(*targets)
      @targets = targets
    end
    
    # Write to all targets.
    def write(*args)
      @targets.each do |target|
        # Strip ANSI coloring unless writing to a terminal.
        args = args.collect { |arg| Ansi::Code.unstyle(arg) } unless target.tty?
        
        target.write(*args)
      end
    end
    
    # Close all targets.
    def close
      @targets.each(&:close)
    end
    
  end
  
end
