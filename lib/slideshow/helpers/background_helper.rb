module Slideshow
  module BackgroundHelper


def gradient( *args )

  # check for optional hash for options
  opts = args.last.kind_of?(Hash) ? args.pop : {}

  colors = args

  clazz = opts[:class] || ( 's9_gradient_linear_'+colors.join('_').gsub( /[(), ]/, '_' ).gsub( /_{2,}/, '_').gsub( /[^-\w]/, '' ) )

  ## generate code for webkit

  webkit  = ""
  webkit << "-webkit-gradient(linear, 0% 0%, 0% 100%, "
  webkit << "from(#{colors.first}), to(#{colors.last})"
  
  # check for additional stop colors
  more_colors = colors[ 1..-2 ] 
  more_colors.each_with_index do |color, i|
    webkit << ", color-stop(#{(1.0/(more_colors.size+1))*(i+1)},#{color})"     
  end 
  webkit  << ")"

  ## generate code for mozilla

  mozilla  = ""
  mozilla << "-moz-linear-gradient(top, "
  mozilla << "#{colors.first}, "  

  # check for additional stop colors
  more_colors = colors[ 1..-2 ] 
  more_colors.each do |color|
    mozilla << "#{color}, "     
  end 

  mozilla << "#{colors.last})"
 

  puts "  Adding CSS for background style rule..."  
  content_for( :css, <<-EOS )
    .#{clazz} { background: #{webkit};
                background: #{mozilla};
              }
  EOS

  # add processing instruction to get style class added to slide 

  puts "  Adding HTML PI for background style class '#{clazz}'..."    
  "<!-- _S9STYLE_ #{clazz} -->\n"
end

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
end # module Slideshow

class Slideshow::Gen
  include Slideshow::BackgroundHelper
end
