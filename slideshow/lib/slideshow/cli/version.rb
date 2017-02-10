# encoding: utf-8

###
# Note: Slideshow.version already used by core, that is, slideshow-models
#

module SlideshowCli

  MAJOR = 3
  MINOR = 1
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )}"
  end

  def self.banner
    "slideshow/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

end # module SlideshowCli
