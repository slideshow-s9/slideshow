module Slideshow
  module MarkdownEngines

  ## note: code moved to its own gem, that is, markdown
  ## see https://github.com/geraldb/markdown
  
  def markdown_to_html( content )
    ##  puts "  Converting Markdown-text (#{content.length} bytes) to HTML using library '#{@markdown_libs.first}' calling '#{mn}'..."
    
    Markdown.new( content ).to_html
  end

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end