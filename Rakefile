require 'hoe'
require './lib/slideshow/version.rb'

Hoe.spec 'slideshow-models' do

  self.version = Slideshow::VERSION

  self.summary = "slideshow-models - slide show (S9) models 'n' machinery for easy (re)use"
  self.description = summary

  self.urls     = ['https://github.com/slideshow-s9/slideshow-models']

  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'

  self.extra_deps = [
    ['props',     '>= 1.1.2'],
    ['logutils',  '>= 0.6.1'],
    ['markdown',  '>= 1.2.0'],
    ['textutils', '>= 0.10.0'],
    ['pakman',    '>= 0.5.0'],
    ['activesupport'],
    ## ['wikicloth', '>= 0.8.0']  make it a soft dependency   # mediawiki markup engine
    ## ['RedCloth','>= 4.2.9']    make it a soft dependency   # textile markup engine
  ]

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
