# encoding: utf-8

module Slideshow
  module MarkdownEngines

  ## note: for now keep it simple use just kramdown
  
  def markdown_to_html( content )    
    ## note: set to gfm (github-flavored markdown) by default
    ##   see http://kramdown.gettalong.org/parser/gfm.html
    kramdown_config = {
      'input'     => 'GFM',
      'hard_wrap' => false
    }

    puts "  Converting markdown-text (#{content.length} bytes) to HTML using kramdown library with #{kramdown_config.inspect}..."
    
    Kramdown::Document.new( content, kramdown_config ).to_html
  end

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end

