module Slideshow
  module MarkdownEngines

  def pandoc_ruby_to_html (content)
    require 'tidy'    
    Tidy.path = '/usr/lib/libtidy.dylib' # or where ever your tidylib resides
    my_nasty_html_string = PandocRuby.new( content ).to_html(:smart)
    Tidy.open(:show_warnings=>true) do |tidy|
      tidy.options.show_body_only = "yes"
      tidy.options.char_encoding = 'utf8'
      tidy.clean(my_nasty_html_string)
    end
  end

  def rdiscount_to_html( content )
    RDiscount.new( content ).to_html
  end
  
  def rpeg_markdown_to_html( content )
    PEGMarkdown.new( content ).to_html
  end
  
  def maruku_to_html( content )
    Maruku.new( content, {:on_error => :raise} ).to_html
  end
  
  def bluecloth_to_html( content )
    BlueCloth.new( content ).to_html
  end
  
  def kramdown_to_html( content )
    Kramdown::Document.new( content ).to_html
  end

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end