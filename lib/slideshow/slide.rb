module Slideshow

  class Slide < Struct.new(:header, :content, :classes)
  
    def to_classic_html
       
      buf  = ""
      buf << "<div class='slide "
      buf << classes    if classes
      buf << "'>\n"      
      
      buf << header     if header
      buf << content    if content
      
      buf << "</div>\n"
      buf       
    end
    
    def to_google_html5
      
      buf  = ""
      buf << "<div class='slide'>\n"      

      if header
        buf << "<header>#{header}</header>\n"
      end
      
      buf << "<section class='"
      buf << classes      if classes      
      buf << "'>\n"
      
      buf << content      if content
      buf << "</section>\n"
      buf << "</div>\n"
      buf
    end
  
  end # class slide

end # module Slideshow