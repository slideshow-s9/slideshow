module TextHelper
  
def __include__( name, opts = {} )
  puts "  Including '#{name}'..." 
  content = File.read( name )
end

end # module TextHelper

Slideshow::Gen.__send__( :include, TextHelper )