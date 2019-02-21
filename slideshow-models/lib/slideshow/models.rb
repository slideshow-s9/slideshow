# encoding: utf-8


# core and stlibs
require 'erb'
require 'pp'
require 'date'
require 'ostruct'
require 'yaml'
require 'json'
require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'
require 'fileutils'


# required gems
require 'active_support/all'

require 'props'             # manage settings/env
require 'logutils'          # logger utils library
require 'fetcher'           # fetch docs and blogs via http, https, etc.

class Env
  def self.slideshowopt
    ENV[ 'SLIDESHOWOPT' ]
  end
end # class Env

require 'textutils'     # text filters and helpers
require 'pakman'        # template pack manager

require 'kramdown'               # default markdown library
require 'kramdown-parser-gfm'    # add GFM (github flavord markdown addon/extension/parser)


# our own code
require 'slideshow/version'   # note: let version always go first
require 'slideshow/opts'
require 'slideshow/config'
require 'slideshow/headers'
require 'slideshow/manifest_helpers'
require 'slideshow/plugin_helpers'
require 'slideshow/models/slide'
require 'slideshow/models/deck'
require 'slideshow/markdown'
require 'slideshow/drops'

require 'slideshow/commands/manifest_finder'
require 'slideshow/commands/fetch'
require 'slideshow/commands/gen'
require 'slideshow/commands/merge'
require 'slideshow/commands/build'
require 'slideshow/commands/list'
require 'slideshow/commands/plugins'
require 'slideshow/commands/quick'


# load built-in (required) helpers/plugins
require 'slideshow/helpers/text_helper'
require 'slideshow/helpers/capture_helper'
require 'slideshow/helpers/step_helper'
require 'slideshow/helpers/background_helper'
require 'slideshow/helpers/source_helper'
require 'slideshow/helpers/directive_helper'

require 'slideshow/helpers/syntax/sh_helper'

# load built-in filters
require 'slideshow/filters/headers_filter'
require 'slideshow/filters/text_filter'
require 'slideshow/filters/debug_filter'
require 'slideshow/filters/slide_filter'



# load built-in (optional) helpers/plugins/engines
#   If a helper fails to load, simply ingnore it
#   If you want to use it install missing required gems e.g.:
#     gem install coderay
#     gem install ultraviolet etc.
BUILTIN_OPT_HELPERS = [
  'slideshow/helpers/syntax/uv_helper.rb',
  'slideshow/helpers/syntax/coderay_helper.rb',
]

BUILTIN_OPT_HELPERS.each do |helper|
  begin
    require(helper)
  rescue Exception => e
    ;
  end
end


# say hello
puts Slideshow.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
