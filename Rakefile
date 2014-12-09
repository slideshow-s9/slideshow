require 'hoe'
require './lib/slideshow/version.rb'

Hoe.spec 'slideshow' do

  self.version = Slideshow::VERSION

  self.summary = 'Slide Show (S9) - A Free Web Alternative to PowerPoint and Keynote in Ruby'
  self.urls     = ['http://slideshow-s9.github.io']

  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'

  self.extra_deps = [
    ['props','>= 1.0.0'],
    ['markdown','>= 1.1.1'],
    ['textutils','>= 0.6.8'],
    ['pakman','>= 0.5.0'],
    ['activesupport', '>= 3.2.6'],
    ['logutils','>= 0.6.0'],
    ['gli', '>= 2.5.6']
    ## ['wikicloth', '>= 0.8.0']  make it a soft dependency   # mediawiki markup engine
    ## ['RedCloth','>= 4.2.9']    make it a soft dependency   # textile markup engine
  ]

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.post_install_message =<<EOS
******************************************************************************

Tip: Try some new template packs. Example:

  $ slideshow install impress.js
  
or
  
  $ slideshow install deck.js
  
and use like
  
  $ slideshow build welcome.text -t impress.js
  
or
  
  $ slideshow build welcome.text -t deck.js
 
or add some extra (plugins) helpers (left, right, etc). Example:
  
  $ slideshow install plugins

Questions? Comments? Send them along to the mailing list.
https://groups.google.com/group/webslideshow

******************************************************************************
EOS
end
