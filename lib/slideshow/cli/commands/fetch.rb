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
    logger.debug "fetch_uri=#{opts.fetch_uri}"
    
    src = opts.fetch_uri
    
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
    
    basename = File.basename( uri.path, '.*' ) # e.g. fullerscreen     (without extension)
    logger.debug "basename: #{basename}"  

    pakpath = File.expand_path( "#{config.config_dir}/templates/#{basename}" )
    logger.debug "pakpath: #{pakpath}"
 
    ## note: code moved to its own gem, that is, pakman
    ## see https://github.com/geraldb/pakman
 
    Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
    
    ## step 2) if shortcut exists (auto include quickstarter manifest w/ same name/key)
    
    if shortcut.present?
      
      src = config.map_quick_shortcut( shortcut )
      return if scr.nil?   # no shortcut found; sorry; returning (nothing more to do)
      
      puts "  Mapping quick shortcut '#{shortcut}' to: #{src}"
 
      uri = URI.parse( src )
      logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
      # downcase basename w/ extension (remove .txt)
      basename = File.basename( uri.path ).downcase.gsub('.txt', '') 
      logger.debug "basename: #{basename}"  

      #### fix: in find manifests
      ## check for directories!!!
      ## exclude directories in match

      ## remove (.txt) in basename
      pakpath = File.expand_path( "#{config.config_dir}/templates/#{basename}" )
      logger.debug "pakpath: #{pakpath}"
 
      Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
    end
    
  end # method run

end # class Fetch

end # module Slideshow