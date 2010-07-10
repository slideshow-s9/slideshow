module BackgroundHelper


def background( *args  )
  
 # make everyting optional; use it like: 
 #   background( code, opts={} )
  
  # check for optional hash for options
  opts = args.last.kind_of?(Hash) ? args.pop : {}

  # check for optional style rule code
  code = args.last.kind_of?(String) ? args.pop : '' 
    
  clazz = opts[:class] || ( 's9'+code.strip.gsub( /[(), ]/, '_' ).gsub( /_{2,}/, '_').gsub( /[^-\w]/, '' ) )
  
  # 1) add background rule to css 
  # e.g. .simple { background: -moz-linear-gradient(top, blue, white); }
  
  unless code.empty?
    puts "  Adding CSS for background style rule..."  
    content_for( :css, <<-EOS )
      .#{clazz} { background: #{code}; }
    EOS
  end
  
  # 2) add processing instruction to get style class added to slide 

  puts "  Adding HTML PI for background style class '#{clazz}'..."    
  "<!-- _S9STYLE_ #{clazz} -->\n"
end 

    
  
end # module BackgroundHelper

class Slideshow::Gen
  include BackgroundHelper
end
