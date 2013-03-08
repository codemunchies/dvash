module Dvash
  
  # Methods to display a random banner for Dvash.
  module Banner
    
    # The list of banners.
    # @return [<String>] An Array of banner Strings.
    def self.list
      @list ||= []
    end
    
    # Retrieve a random banner.
    # @return [String] A random banner for Dvash.
    def self.random
      # `DATA` is an IO (really just output) to read from the section of the
      # current file after `__END__` - http://caiustheory.com/why-i-love-data
      # `String#split` simple splits a String by the delimiter given and
      # `Array#sample` returns a random object from the Array.
      DATA.read.split('-' * 50).sample
    end
    
    list << <<-EOS
      .------..------..------..------..------.
      |D.--. ||V.--. ||A.--. ||S.--. ||H.--. |
      | :/\: || :(): || (\\/) || :/\\: || :/\\: |
      | (__) || ()() || :\\/: || :\\/: || (__) |
      | '--'D|| '--'V|| '--'A|| '--'S|| '--'H|
      `------'`------'`------'`------'`------'
    EOS
    
    list << <<-EOS
      @@@@@@@   @@@  @@@   @@@@@@    @@@@@@   @@@  @@@  
      @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@   @@@  @@@  
      @@!  @@@  @@!  @@@  @@!  @@@  !@@       @@!  @@@  
      !@!  @!@  !@!  @!@  !@!  @!@  !@!       !@!  @!@  
      @!@  !@!  @!@  !@!  @!@!@!@!  !!@@!!    @!@!@!@!  
      !@!  !!!  !@!  !!!  !!!@!!!!   !!@!!!   !!!@!!!!  
      !!:  !!!  :!:  !!:  !!:  !!!       !:!  !!:  !!!  
      :!:  !:!   ::!!:!   :!:  !:!      !:!   :!:  !:!  
       :::: ::    ::::    ::   :::  :::: ::   ::   :::  
      :: :  :      :       :   : :  :: : :     :   : :
    EOS
    
    list << <<-EOS
      	      ^^  .-=-=-=-.  ^^
      ^^        (`-=-=-=-=-`)         ^^
              (`-=-=-=-=-=-=-`)  ^^         ^^
        ^^   (`-=-=-=-=-=-=-=-`)   ^^                            ^^
            ( `-=-=-=-(@)-=-=-` )      ^^
            (`-=-=-=-=-=-=-=-=-`)  ^^
            (`-=-=-=-=-=-=-=-=-`)              ^^
            (`-=-=-=-=-=-=-=-=-`)                      ^^
            (`-=-=-=-=-=-=-=-=-`)  ^^
             (`-=-=-=-=-=-=-=-`)          ^^
              (`-=-=-=-=-=-=-`)  ^^                 ^^
      dvash     (`-=-=-=-=-`)
                 `-=-=-=-=-`
    EOS
    
    list << <<-EOS
              _______________
            //~~~~~~~~~~~~~~~\\\\  |
       0  / /_________________\\ \\| 0
        ---------------------------
      / /======|=D=V=A=S=H=|======\\ \
      \\_____________________________/
      \\    _______       _______    /
      |\\ _/|__|__|\\_____/|__|__|\\_ /|
      |      |`V'  `---'  `V'|      |
      |______|               |______|
    EOS
  end
  
end
