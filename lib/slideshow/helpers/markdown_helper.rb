module Slideshow
  module MarkdownHelper

def s9_class( clazz )
  "{: .#{clazz.strip}}"
end

def clear
  "{: .clear}"
end


end # module MarkdownHelper
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownHelper
end