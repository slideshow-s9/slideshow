require 'rubygems'

Gem::Specification.new do |spec|
  spec.name = 'slideshow'
  spec.version = '0.7.4'
  spec.summary = "Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby"
  spec.homepage = 'http://slideshow.rubyforge.org'
  spec.rubyforge_project = 'slideshow'
  spec.authors  = [ 'Gerald Bauer' ]
  spec.email    = 'webslideshow@googlegroups.com'
  spec.files = Dir[ 'lib/**/*', 'bin/**/*' ]
  spec.require_path = 'lib'
  spec.executables = [ 'slideshow' ]

  spec.add_dependency( 'RedCloth', [">= 4.0.0"] )
  spec.add_dependency( 'BlueCloth',[">= 1.0.0"] )
  
  ## now optional; if required/desired install using gem install maruku
  # spec.add_dependency( 'maruku', [">=0.5.8"] )
  
  ## move to optional plugin/extension
  # spec.add_dependency( 'hpricot', [">=0.6"] )
  # spec.add_dependency( 'ultraviolet', [">=0.10.2"] )
end