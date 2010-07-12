module Slideshow
  module TextileEngines

  def redcloth_java_fix_escape_nonascii( txt )
    txt.chars.map{ |x| x.size > 1 ? "&##{x.unpack("U*")};" : x }.join
  end

  def redcloth_java_fix_escape_nonascii_exclude_pre( txt )

    buf  = ""
    from = 0
 
    while (pos = txt.index( /<pre.*?>.*?<\/pre>/m, from ))
      # add text before pre block escaped
      buf << redcloth_java_fix_escape_nonascii( txt[ from, pos-from] )
     
      # add pre block unescaped (otherwise html entities get escaped twice)
      from = Regexp.last_match.end(0)
      buf << txt[pos, from-pos]
    end
    buf << redcloth_java_fix_escape_nonascii( txt[from, txt.length-from] )
   
    buf
  end 


  def textile_to_html( content )    
    puts "  Converting Textile-text (#{content.length} bytes) to HTML..."
    
    # JRuby workaround for RedCloth 4 multi-byte character bug
    #  see http://jgarber.lighthouseapp.com/projects/13054/tickets/149-redcloth-4-doesnt-support-multi-bytes-content
    # basically convert non-ascii chars (>127) to html entities
    
    if RedCloth::EXTENSION_LANGUAGE == "Java"
      puts "  Patching RedCloth for Java; converting non-Ascii/multi-byte chars to HTML-entities..." 
      content = redcloth_java_fix_escape_nonascii_exclude_pre( content )
    end
    
    # turn off hard line breaks
    # turn off span caps (see http://rubybook.ca/2008/08/16/redcloth)
    red = RedCloth.new( content, [:no_span_caps] )
    red.hard_breaks = false
    content = red.to_html
  end

end   # module TextileEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::TextileEngines
end