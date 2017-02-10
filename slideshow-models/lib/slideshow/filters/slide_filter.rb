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

  
end  # module SlideFilter
end # module Slideshow

class Slideshow::Gen
  include Slideshow::SlideFilter
end

