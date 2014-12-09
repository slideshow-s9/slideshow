# encoding: utf-8


# core and stlibs
require 'erb'
require 'fileutils'
require 'pp'
require 'uri'
require 'net/http'
require 'net/https'
require 'ostruct'
require 'date'
require 'yaml'
require 'cgi'

# required gems
require 'active_support/all'

require 'props'             # manage settings/env
require 'logutils'       # logger utils library

require 'markdown'          # default markdown library
require 'fetcher'           # fetch docs and blogs via http, https, etc.


class Env
  def self.slideshowopt
    ENV[ 'SLIDESHOWOPT' ]
  end
end # class Env

require 'textutils'     # text filters and helpers
require 'pakman'        # template pack manager


# our own code
require 'slideshow/version'   # note: let version always go first
require 'slideshow/headers'
require 'slideshow/config'
require 'slideshow/manifest_helpers'
require 'slideshow/plugin_helpers'
require 'slideshow/slide'

require 'slideshow/commands/fetch'
require 'slideshow/commands/gen'
require 'slideshow/commands/list'
require 'slideshow/commands/plugins'
require 'slideshow/commands/quick'


require 'slideshow/markup/markdown'
require 'slideshow/markup/mediawiki'
require 'slideshow/markup/textile'


# load built-in (required) helpers/plugins
require 'slideshow/helpers/text_helper'
require 'slideshow/helpers/capture_helper'
require 'slideshow/helpers/step_helper'
require 'slideshow/helpers/background_helper'
require 'slideshow/helpers/source_helper'
require 'slideshow/helpers/directive_helper'
require 'slideshow/helpers/markdown_helper'

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
  'slideshow/markup/rest.rb',
]

BUILTIN_OPT_HELPERS.each do |helper| 
  begin
    require(helper)
  rescue Exception => e
    ;
  end
end
