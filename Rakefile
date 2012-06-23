require 'hoe'
require './lib/slideshow/version.rb'

Hoe.spec 'slideshow' do
  
  self.version = Slideshow::VERSION
  
  self.summary = 'Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby'
  self.urls     = ['http://slideshow.rubyforge.org']
  
  
  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'
  
  self.extra_deps = [
    ['props','>= 1.0.0'],
    ['markdown','>= 1.0.0'],
    ['textutils','>= 0.2.0'],
    ['pakman','>= 0.4.0'],
    ['activesupport', '>= 3.2.6'],
    ['RedCloth','>= 4.2.9']
  ]
    
  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.markdown'
  self.history_file = 'History.markdown'
  
  self.post_install_message =<<EOS
******************************************************************************

Questions? Comments? Send them along to the mailing list.
https://groups.google.com/group/webslideshow

******************************************************************************
EOS
end