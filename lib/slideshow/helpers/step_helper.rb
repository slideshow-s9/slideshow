module Slideshow
  module StepHelper

  
def step( opts={}, &blk )
     
  puts "  Adding HTML div block for step (incremental display)..."
    
  text = capture_erb(&blk)
      
  before  = "<!-- begin step #{opts.inspect} -->\n"
  before << "<div class='step' markdown='block'>\n"
  
  after   = "</div>\n"  
  after  << "<!-- end step -->\n"

  html  = ""
  html << guard_block( before )
  html << text
  html << guard_block( after )

  concat_erb( html, blk.binding )
  return
end
  
  
end # module StepHelper
end # module Slideshow

class Slideshow::Gen
  include Slideshow::StepHelper
end

