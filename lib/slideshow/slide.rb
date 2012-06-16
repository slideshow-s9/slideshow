module Slideshow

  class Slide

    attr_accessor :logger

    # NB: unparsed html source (use content_without_header
    #  for content without option header)
      
    attr_accessor :content
    attr_accessor :content_without_header
    attr_accessor :header
    attr_accessor :classes
  
    def initialize( content, options )
      @logger       = options.logger
      @header_level = options.header_level
      
      @content = content
      
      @header                 = nil
      @content_without_header = nil
      @classes                = nil   # NB: style classes as all in one string
      @data    = {}
      
      parse()
    end

    def parse
      ## pass 1) check for (css style) classes and data attributes
      ## check for css style classes
      from = 0
      while( pos = @content.index( /<!-- _S9(SLIDE|STYLE)_(.*?)-->/m, from ))
        logger.debug "  adding css classes from pi >#{$1.downcase}<: >#{$2.strip}<"

        from = Regexp.last_match.end(0)  # continue search later from here
        
        values = $2.strip.dup
        
        # remove data values (eg. x=-20 scale=4) and store in data hash
        values.gsub!( /([-\w]+)[ \t]*=[ \t]*([-\w\.]+)/ ) do |_|
          logger.debug "    adding data pair: key=>#{$1.downcase}< value=>#{$2}<"
          @data[ $1.downcase.dup ] = $2.dup
          " "  # replace w/ space
        end
        
        values.strip!  # remove spaces  # todo: use squish or similar and check for empty string
                
        if @classes.nil?
          @classes = values
        else
          @classes << " #{values}"
        end
      end

      ## pass 2) split slide source into header (optional) and content/body

      ## todo: add option split on h1/h2 etc.

      # try to extract first header using non-greedy .+? pattern;
      # tip test regex online at rubular.com
      #  note/fix: needs to get improved to also handle case for h1 wrapped into div

      if @header_level == 2
        pattern = /^(.*?)(<h2.*?>.*?<\/h2>)(.*)/m
      else # assume header level 1
        pattern = /^(.*?)(<h1.*?>.*?<\/h1>)(.*)/m
      end

      if @content =~ pattern
        @header  = $2
        @content_without_header = ($1 ? $1 : '') + ($3 ? $3 : '')
        logger.debug "  adding slide with header (h1):\n#{@header}"
      else
        @header = nil    # todo: set to '' empty string? why not?
        @content_without_header = @content
        logger.debug "  adding slide with *no* header:\n#{@content}"
      end
    end  # method parse


    def data_attributes
      buf = ""
      @data.each do | key,value |
        buf << "data-#{key}='#{value}' "
      end
      buf
    end 

################################
#### convenience helpers
  
    def to_classic_html
      buf  = ""
      buf << "<div class='slide "
      buf << classes    if classes
      buf << "'>\n"
      buf << content
      buf << "</div>\n"
      buf
    end
    
    def to_google_html5
      buf  = ""
      buf << "<div class='slide'>\n"
      buf << "<header>#{header}</header>\n"   if header
      buf << "<section "
      buf << "class='#{classes}'"             if classes
      buf << "'>\n"
      buf << content_without_header           if content_without_header
      buf << "</section>\n"
      buf << "</div>\n"
      buf
    end
  
  end # class Slide

end # module Slideshow