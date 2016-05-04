# encoding: utf-8

module Slideshow

class Fetch

  
  include LogUtils::Logging
  
  def initialize( config )
    @config  = config
  end

  attr_reader :config


  def fetch_all
    config.default_fetch_shortcuts.each do |shortcut|
      fetch( shortcut )
    end
  end


  def fetch( shortcut_or_source )

    logger.debug "fetch >#{shortcut_or_source}<"
    
    ## check for builtin shortcut (assume no / or \) 
    if shortcut_or_source.index( '/' ).nil? && shortcut_or_source.index( '\\' ).nil?
      shortcut = shortcut_or_source
      sources = config.map_fetch_shortcut( shortcut )

      if sources.empty?
        puts "** Error: No mapping found for shortcut '#{shortcut}'."
        return
      end
      puts "  Mapping fetch shortcut '#{shortcut}' to: #{sources.join(',')}"
    else
      sources = [shortcut_or_source]  # pass arg through unmapped
    end

    sources.each do |source|
      
      ## if manifest includes .plugin assume it's a plugin
      if source.include?( '.txt.plugin' ) || source.include?( '.plugin.txt' )
        fetch_plugin( source )
      elsif source.include?( '.txt.quick' ) || source.include?( '.quick.txt' )
        fetch_quick( source )
      else # otherwise assume it's a template pack
        fetch_template( source )
      end

    end

  end # method run


  def fetch_template( src )
    # src = 'http://github.com/geraldb/slideshow/raw/d98e5b02b87ee66485431b1bee8fb6378297bfe4/code/templates/fullerscreen.txt'
    # src = 'http://github.com/geraldb/sandbox/raw/13d4fec0908fbfcc456b74dfe2f88621614b5244/s5blank/s5blank.txt'
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
    pakname = File.basename( uri.path ).downcase.gsub('.txt','')
    pakpath = File.expand_path( "#{config.config_dir}/templates/#{pakname}" )
    
    logger.debug "packname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
  
    Pakman::Fetcher.new.fetch_pak( src, pakpath )
  end

  def fetch_quick( src )
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
    # downcase basename w/ extension (remove .txt)
    pakname = File.basename( uri.path ).downcase.gsub('.txt','')
    pakpath = File.expand_path( "#{config.config_dir}/templates/#{pakname}" )

    logger.debug "pakname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
 
    Pakman::Fetcher.new.fetch_pak( src, pakpath )
  end

  def fetch_plugin( src )
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
    # downcase basename w/ extension (remove .txt)
    pakname = File.basename( uri.path ).downcase.gsub('.txt','').gsub('.plugin','')
    pakpath = File.expand_path( "#{config.config_dir}/plugins/#{pakname}" )

    logger.debug "pakname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
 
    Pakman::Fetcher.new.fetch_pak( src, pakpath )
  end

end # class Fetch

end # module Slideshow