module Slideshow
  module MarkdownEngines

  ## note: code move to its own gem, that is, markdown_select
  ## see https://github.com/geraldb/markdown_select
  
  def markdown_to_html( content )
    ##  puts "  Converting Markdown-text (#{content.length} bytes) to HTML using library '#{@markdown_libs.first}' calling '#{mn}'..."
    
    MarkdownSelect.new( content ).to_html
  end

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end