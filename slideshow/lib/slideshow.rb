# encoding: utf-8

$RUBYLIBS_DEBUG = true


require 'slideshow/models'

require 'slideshow/templates'   ## for now add builtin templates (remove later? why? why not?)

## todo/fix: check slideshow-models - remove Env.slideshowopt here or in models?
#
#class Env
#  def self.slideshowopt
#    ENV[ 'SLIDESHOWOPT' ]
#  end
#end # class Env


## more 3rd party gems

require 'gli'


# our own code
require 'slideshow/cli/version'        # note: let version always go first
require 'slideshow/cli/opts'
require 'slideshow/cli/main_utils'
require 'slideshow/cli/main'



module Slideshow

=begin
  def self.main_old
    
    # allow env variable to set RUBYOPT-style default command line options
    #   e.g. -o slides -t <your_template_manifest_here>
    slideshowopt = Env.slideshowopt
    
    args = []
    args += slideshowopt.split if slideshowopt
    args += ARGV.dup
    
    Runner.new.run(args)
  end
=end

  def self.main
    exit Tool.new.run(ARGV)
  end


end # module Slideshow


Slideshow.main   if __FILE__ == $0
