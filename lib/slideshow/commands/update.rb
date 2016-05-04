# encoding: utf-8

module Slideshow


###
#  update/fetch shortcut/registry slideshow.index.yml
#    

# todo/why/why not??
#   - *ALWAYS* fetch index before an "online" fetch operation?
#     why cache or use built-in version?
#     use cached/built-in version only as fallback?



class Update

  
  include LogUtils::Logging
  
  def initialize( config )
    @config  = config
  end

  attr_reader :config


  def update   # update shortcut index
    dest =  config.shortcut_index_file
    
    destfull = File.expand_path( dest )
    destpath = File.dirname( destfull )
    FileUtils.makedirs( destpath ) unless File.directory?( destpath )

    logger.debug "destfull=>#{destfull}<"
    logger.debug "destpath=>#{destpath}<"

    ## todo/fix: use a config setting for index url (do NOT hard core)
    src = 'https://raw.github.com/slideshow-s9/registry/master/slideshow.index.yml'

    puts "Updating shortcut index - downloading '#{src}'..."
    ::Fetcher::Worker.new.copy( src, destfull )
  end

end # class Update

end # module Slideshow

