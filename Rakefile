require 'hoe'
require './lib/slideshow/version.rb'

Hoe.spec 'slideshow-models' do

  self.version = Slideshow::VERSION

  self.summary = "slideshow-models - slide show (S9) models 'n' machinery for easy (re)use"
  self.description = summary

  self.urls     = ['https://github.com/slideshow-s9/slideshow-models']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'

  self.extra_deps = [
    ['props',     '>= 1.1.2'],
    ['logutils',  '>= 0.6.1'],
    ['kramdown',  '>= 1.10.0'],
    ['textutils', '>= 0.10.0'],
    ['pakman',    '>= 0.7.0'],
    ['activesupport'],
  ]

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
