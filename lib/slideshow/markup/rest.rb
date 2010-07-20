require 'pandoc-ruby'

module Slideshow
  module RestEngines  # reStructuredText

  def rest_to_html( content )
    puts "  Converting reStructuredText (#{content.length} bytes) to HTML..."

    content = PandocRuby.new( content, :from => :rst, :to => :html ).convert
  end
    
end   # module RestEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::RestEngines
end  
