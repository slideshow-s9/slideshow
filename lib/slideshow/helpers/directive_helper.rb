module Slideshow
  module DirectiveHelper

# css directive:
#
# lets you use:
#   %css
#     -- inline css code here
#   %end
#
# shortcut for:
#   %content_for :css
#     -- inline css code here
#   %end
#  or
#  <% content_for :css do %>
#    -- inline css code here
#  <% end %>

def css( &block )
  content_for( :css, nil, &block )
end
    
def slide( params )
  # note: to avoid runons with blocks (wrap in double newlines)
  
  "\n\n<!-- _S9SLIDE_ #{params ? params : ''} -->\n\n"
end

def style( params )
  # note: to avoid runons with blocks (wrap in double newlines)

  "\n\n<!-- _S9STYLE_ #{params ? params : ''} -->\n\n"
end


end # module DirectiveHelper
end # module Slideshow

class Slideshow::Gen
  include Slideshow::DirectiveHelper
end

