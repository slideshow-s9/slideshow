module StepHelper

  
def step( opts={}, &blk )
     
  puts "  Adding HTML div block for step (incremental display)..."
    
  text = capture_erb(&blk)
      
  before  = "<!-- begin step #{opts.inspect} -->\n"
  before << "<div class='step' markdown='block'>\n"
  
  after   = "</div>\n"  
  after  << "<!-- end step -->\n"

  html  = ""
  html << guard_text( before )
  html << text
  html << guard_text( after )

  concat_erb( html, blk.binding )
  return
end
  
  
end # module StepHelper

class Slideshow::Gen
  include StepHelper
end

