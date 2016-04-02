# encoding: utf-8

module Slideshow


module DeckFilter

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

  content = content.gsub( /<h1/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}"
  end
  
  puts "  Adding #{slide_count} slide breaks (using h1 rule)..."
  
  content
end

def add_slide_directive_before_h2( content )

  slide_count = 0

  content = content.gsub( /<h2/ ) do |match|
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

  content = content.gsub( /<div[^>]*>\s*<h1/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}" 
  end

  puts "  Adding #{slide_count} slide breaks (using div_h1 rule)..."

  content
end
    
end # module DeckFilter



class Deck

  include LogUtils::Logging
  include DeckFilter     # e.g. add_slide_directive_before_h1


  attr_accessor :content     ## all-in-one content (that is, incl. all slides )
  attr_accessor :slides
  

  def initialize( source, header_level: 1, use_slide: false )
    @source = source  ## keep a copy of the original source (input)

    @header_level = header_level   # e.g. 1 or 2   -- todo/fix: allow more options e.g. 1..2 etc.
    @use_slide    = use_slide      # e.g. opts.slide? -- only allow !SLIDE directives fo slide breaks?

    @slides  = []
    @content = ''  # note: gets (re)build from slides in parse 

    parse()
  end


  def parse
    #############################
    # step 1 - add slide breaks
  
    @content = @source
  
    if @use_slide  # only allow !SLIDE directives fo slide breaks?
       # do nothing (no extra automagic slide breaks wanted)
    else  
      if @header_level == 2
        @content = add_slide_directive_before_h2( @content )
      else # assume level 1
        @content = add_slide_directive_before_h1( @content )
      end
    end


    ### todo/fix: add back dump to file (requires @name and outpath !!!!)
    ### dump_content_to_file_debug_html( content )


    #############################################################
    # step 2 -  use generic slide break processing instruction to
    #   split content into slides

    counter = 0
    chunks = []
    buf = ""

     
    @content.each_line do |line|
       if line.include?( '<!-- _S9SLIDE_' ) || line.include?( '<!-- @SLIDE' )  ## add new format  
          if counter > 0   # found start of new slide (and, thus, end of last slide)
            chunks << buf  # add slide to slide stack
            buf = ""         # reset slide source buffer
          else  # counter == 0
            # check for first slide with missing leading SLIDE directive (possible/allowed in takahashi, for example)
            ##  remove html comments and whitspaces (still any content?)
            ### more than just whitespace? assume its  a slide
            if buf.gsub(/<!--.*?-->/m, '').gsub( /[\n\r\t ]/, '').length > 0
              logger.debug "add slide with missing leading slide directive >#{buf}< with slide_counter == 0"
              chunks << buf
              buf = ""
            else
              logger.debug "** note: skipping slide >#{buf}< with counter == 0"
            end
          end
          counter += 1
       end
       buf << line
    end
  
    if counter > 0
      chunks << buf     # add slide to slide stack
      buf = ""            # reset slide source buffer 
    end


    @slides = []
    chunks.each do |chunk|
      @slides << Slide.new( chunk, header_level: @header_level )
    end


    puts "#{@slides.size} slides found:"
    
    @slides.each_with_index do |slide,i|
      print "  [#{i+1}] "
      if slide.header.present?
        print slide.header
      else
        # remove html comments
        print "-- no header -- | #{slide.content.gsub(/<!--.*?-->/m, '').gsub(/\n/,'$')[0..40]}"
      end
      puts
    end

    ## rebuild all-in-one content (incl. all slides)       
    @content = ""
    @slides.each do |slide|
      @content << slide.to_classic_html
    end  
  end  # method parse


end # class Deck

end # class Slideshow
