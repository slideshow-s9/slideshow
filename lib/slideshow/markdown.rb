# encoding: utf-8

module Slideshow
  module MarkdownEngines

  ## note: for now keep it simple use just kramdown
  
  def markdown_to_html( content )
    ##  puts "  Converting Markdown-text (#{content.length} bytes) to HTML using library '#{@markdown_libs.first}' calling '#{mn}'..."
    ## Markdown.new( content ).to_html
    
    ## todo/fix:
    ##   set to gfm (github-flavored markdown) by default
    
    Kramdown::Document.new( content ).to_html
  end

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end
