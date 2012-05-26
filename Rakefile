require 'hoe'
require './lib/slideshow.rb'

Hoe.spec 'slideshow' do
  
  self.version = Slideshow::VERSION
  
  self.summary = 'Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby'
  self.url     = 'http://slideshow.rubyforge.org'
  
  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'
  
  self.extra_deps = [
    ['RedCloth','>= 4.2.9'],
    ['markdown_select','>= 0.1.3']
  ]
  
  self.remote_rdoc_dir = 'doc'
  
  # switch extension to .rdoc for gihub formatting
  self.readme_file  = 'README.rdoc'
  self.history_file = 'History.rdoc'
  
  self.post_install_message =<<EOS
******************************************************************************

Questions? Comments? Send them along to the mailing list.
https://groups.google.com/group/webslideshow

******************************************************************************
EOS
end