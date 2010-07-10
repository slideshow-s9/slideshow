module MarkdownHelper

def s9_class( clazz )
  "{: .#{clazz.strip}}"
end

def clear
  "{: .clear}"
end


end # module MarkdownHelper

class Slideshow::Gen
  include MarkdownHelper
end