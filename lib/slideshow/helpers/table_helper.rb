module Slideshow
  module TableHelper

# todo: add center, plus generic col helper

  
def left( opts={}, &blk )
   
  width = opts.fetch( :width, "50%" )
  clazz = opts.fetch( :class, nil )
   
  puts "  Adding HTML for left column (using table layout)..."
    
  text = capture_erb(&blk)
      
  before  = "<!-- begin left #{opts.inspect} -->\n"
  before << "<div class='#{clazz}'>\n"  if clazz  
  before << "<table width='100%'><tr><td width='#{width}' markdown='block' style='vertical-align: top;'>\n"
    
  after   = "</td>\n"  
  after  << "<!-- end left -->\n"

  html  = ""
  html << guard_block( before )
  html << text
  html << guard_block( after )

  concat_erb( html, blk.binding )
  return
end
  
def right( opts={}, &blk )

  width = opts.fetch( :width, "50%" )
  clazz = opts.fetch( :class, nil )
   
  puts "  Adding HTML for right column (using table layout)..."
    
  text = capture_erb(&blk)
    
  before  = "<!-- begin right #{opts.inspect} -->\n" 
  before << "<td width='#{width}' markdown='block' style='vertical-align: top;'>\n"  
    
  after   = "</td></tr></table>\n"
  after  << "</div>\n"  if clazz    
  after  << "<!-- end right -->\n"

  html  = ""
  html << guard_block( before )
  html << text
  html << guard_block( after )
      
  concat_erb( html, blk.binding )
  return
end
  
  
end # module TableHelper
end # module Slideshow

class Slideshow::Gen
  include Slideshow::TableHelper
end
