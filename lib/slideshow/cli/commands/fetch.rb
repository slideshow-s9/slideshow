module Slideshow

class Fetch

### fix: remove opts, use config (wrapped!!)
  
  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config


  def run
    if opts.fetch_all?
      config.default_fetch_shortcuts.keys.each do |shortcut|
        fetch_pak( shortcut )
      end
    else
      fetch_pak( opts.fetch_uri )
    end
  end

private
  def fetch_pak( src )
    
    logger.debug "src=>#{src}<"
    
    ## check for builtin shortcut (assume no / or \) 
    if src.index( '/' ).nil? && src.index( '\\' ).nil?
      shortcut = src.clone
      src = config.map_fetch_shortcut( src )
      
      if src.nil?
        puts "** Error: No mapping found for fetch shortcut '#{shortcut}'."
        return
      end
      puts "  Mapping fetch shortcut '#{shortcut}' to: #{src}"
    else
      shortcut = nil
    end
 
    # src = 'http://github.com/geraldb/slideshow/raw/d98e5b02b87ee66485431b1bee8fb6378297bfe4/code/templates/fullerscreen.txt'
    # src = 'http://github.com/geraldb/sandbox/raw/13d4fec0908fbfcc456b74dfe2f88621614b5244/s5blank/s5blank.txt'
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
    pakname = File.basename( uri.path ).downcase.gsub('.txt','')
    pakpath = File.expand_path( "#{config.config_dir}/templates/#{pakname}" )
    
    logger.debug "packname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
  
    Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
    
    ###################################
    ## step 2) if shortcut exists (auto include quickstarter manifest w/ same name/key)
    
    if shortcut.present?
      
      src = config.map_quick_shortcut( shortcut )
      return if src.nil?   # no shortcut found; sorry; returning (nothing more to do)
      
      puts "  Mapping quick shortcut '#{shortcut}' to: #{src}"
 
      uri = URI.parse( src )
      logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
      # downcase basename w/ extension (remove .txt)
      pakname = File.basename( uri.path ).downcase.gsub('.txt','')
      pakpath = File.expand_path( "#{config.config_dir}/templates/#{pakname}" )

      logger.debug "pakname >#{pakname}<"
      logger.debug "pakpath >#{pakpath}<"
 
      Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
    end
    
  end # method run

end # class Fetch

end # module Slideshow