module SourceHelper

def source( name, opts={})

  text = opts[:text] || '(Source)' 

  # add .text file extension if missing (for convenience)
  name << ".text"   if File.extname( name ).empty?

  base = 'http://github.com/geraldb/slideshow/raw/master/samples'

  buf = "<a href='#{base}/#{name}'>#{text}</a>"
  
  puts "  Adding HTML for source link to '#{name}'..."      
  
  guard_text( buf )      
end
    
  
end # module SourceHelper

class Slideshow::Gen
  include SourceHelper
end
