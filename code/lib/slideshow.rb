$KCODE = 'utf'

LIB_PATH = File.dirname(__FILE__)
$:.unshift(LIB_PATH) unless $:.include?(LIB_PATH) || $:.include?(File.expand_path(LIB_PATH))

# core and stlibs
require 'optparse'
require 'erb'
require 'logger'
require 'fileutils'
require 'ftools'
require 'pp'

# required gems
require 'redcloth'

# own code
require 'slideshow/opts'
require 'slideshow/gen'

module Slideshow

  VERSION = '0.7.8'

  def Slideshow.main
    Gen.new.run(ARGV)
  end

end # module Slideshow

# load built-in (required) helpers/plugins
require 'slideshow/helpers/text_helper.rb'
require 'slideshow/helpers/capture_helper.rb'

# load built-in (optional) helpers/plugins
#   If a helper fails to load, simply ingnore it
#   If you want to use it install missing required gems e.g.:
#     gem install coderay
#     gem install ultraviolet etc.
BUILTIN_OPT_HELPERS = [
  'slideshow/helpers/uv_helper.rb',
  'slideshow/helpers/coderay_helper.rb',
]

BUILTIN_OPT_HELPERS.each do |helper| 
  begin
    require(helper)
  rescue Exception => e
    ;
  end
end

Slideshow.main if __FILE__ == $0