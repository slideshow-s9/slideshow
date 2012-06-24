# encoding: utf-8
module Slideshow
  module SlideFilter


  def takahashi_slide_breaks( content )
    
    inline_count = 0
    line_count = 0

    ###########################
    ## allows   one // two // three
    
    content.gsub!( /\b[ ]+\/{2}[ ]+\b/) do |match|
      inline_count += 1
      ## todo: use slide('') directive helper?
      "\n\n<!-- _S9SLIDE_  -->\n\n"
    end
    
    ############################
    ## allows
    ##
    ##  one
    ##  //
    ##  two
    ##  //
    ##  three
    
    content.gsub!( /^[ ]*\/{2}[ ]*$/ ) do |match|
      line_count += 1
      ## todo: use slide('') directive helper?
      "\n\n<!-- _S9SLIDE_  -->\n\n"
    end

    puts "  Adding #{inline_count+line_count} takahashi slide breaks (#{inline_count} //-inline, #{line_count} //-line)..."
        
    content
  end


# add slide directive before h1 (tells slideshow gem where to break slides)
#
# e.g. changes:
# <h1 id='optional' class='optional'>
#  to
#  html comment -> _S9SLIDE_ (note: rdoc can't handle html comments?) 
# <h1 id='optional' class='optional'>

def add_slide_directive_before_h1( content )

  # mark h1 for getting wrapped into slide divs
  # note: use just <h1 since some processors add ids e.g. <h1 id='x'>

  slide_count = 0

  content.gsub!( /<h1/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}"
  end
  
  puts "  Adding #{slide_count} slide breaks (using h1 rule)..."
  
  content
end

def add_slide_directive_before_h2( content )

  slide_count = 0

  content.gsub!( /<h2/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}"
  end
  
  puts "  Adding #{slide_count} slide breaks (using h2 rule)..."
  
  content
end



# add slide directive before div h1 (for pandoc-generated html)
#
# e.g. changes:
# <div id='header'>
# <h1 id='optional' class='optional'>
#  to
#  html comment -> _S9SLIDE_ 
# <div id='header'>
# <h1 id='optional' class='optional'>


def add_slide_directive_before_div_h1( content )

  slide_count = 0

  content.gsub!( /<div[^>]*>\s*<h1/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}" 
  end

  puts "  Adding #{slide_count} slide breaks (using div_h1 rule)..."

  content
end

  
end  # module SlideFilter
end # module Slideshow

class Slideshow::Gen
  include Slideshow::SlideFilter
end
