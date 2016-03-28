# encoding: utf-8

module Slideshow

class HeadersDrop < Liquid::Drop

  def initialize( headers )
    @headers = headers
  end

  def before_method( method )
    ## note: assume returned value is always a string or nil (if key not found)
    puts "  call HeadersDrop#before_method >#{method}< : #{method.class}"
    value = @headers[ method ]
    value
  end

end # class HeadersDrop


class SlideDrop < Liquid::Drop

  def initialize( slide )
    @slide = slide
  end

  def content()                 puts "  call SlideDrop#content";             @slide.content; end
  def content_without_header()  puts "  call SlideDrop#content_w/o_header";  @slide.content_without_header;  end
  def header()                  puts "  call SlideDrop#header";              @slide.header; end
  def classes()                 puts "  call SlideDrop#classes";             @slide.classes; end
  def data_attributes()         puts "  call SlideDrop#data_attributes";     @slide.data_attributes; end
end ## class SlideDrop


end # module Slideshow
