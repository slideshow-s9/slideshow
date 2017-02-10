# encoding: utf-8


# our own code
require 'slideshow/templates/version'  # Note: let version always go first


# say hello
puts SlideshowTemplates.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
