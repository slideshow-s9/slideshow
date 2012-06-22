# encoding: utf-8

###
# NB: for local testing run like:
#
# 1.8.x: ruby -Ilib -rrubygems lib/slideshow.rb
# 1.9.x: ruby -Ilib lib/slideshow.rb


# core and stlibs
require 'optparse'
require 'erb'
require 'logger'
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

require 'redcloth'          # default textile library
require 'markdown'          # default markdown library
require 'fetcher'           # fetch docs and blogs via http, https, etc.

require 'props'             # manage settings/env

class Env
  def self.slideshowopt
    ENV[ 'SLIDESHOWOPT' ]
  end
end # class Env

require 'textutils'     # text filters and helpers
require 'pakman'        # template pack manager


# our own code
require 'slideshow/version'
require 'slideshow/headers'
require 'slideshow/config'
require 'slideshow/manifest_helpers'
require 'slideshow/plugin_helpers'
require 'slideshow/slide'

require 'slideshow/cli/opts'
require 'slideshow/cli/runner'
require 'slideshow/cli/commands/fetch'
require 'slideshow/cli/commands/gen'
require 'slideshow/cli/commands/gen_templates'
require 'slideshow/cli/commands/list'
require 'slideshow/cli/commands/plugins'
require 'slideshow/cli/commands/quick'


require 'slideshow/markup/textile'
require 'slideshow/markup/markdown'

# load built-in (required) helpers/plugins
require 'slideshow/helpers/text_helper'
require 'slideshow/helpers/capture_helper'
require 'slideshow/helpers/analytics_helper'
require 'slideshow/helpers/table_helper'
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


module Slideshow

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end
  
  # version string for generator meta tag (includes ruby version)
  def self.generator
    "Slide Show (S9) #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end


  def self.main
    
    # allow env variable to set RUBYOPT-style default command line options
    #   e.g. -o slides -t <your_template_manifest_here>
    slideshowopt = Env.slideshowopt
    
    args = []
    args += slideshowopt.split if slideshowopt
    args += ARGV.dup
    
    Runner.new.run(args)
  end

end # module Slideshow

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

Slideshow.main if __FILE__ == $0