module Slideshow

class Fetch

  include Manifest   # gets us methods like installed_template_manifests, etc.

### fix: remove opts, use config (wrapped!!)
  
  def initialize( logger, opts, config, headers )
    @logger  = logger
    @opts    = opts
    @config  = config
    @headers = headers
  end

  attr_reader :logger, :opts, :config, :headers

  def fetch_file( dest, src )
    
     ## note: code moved to its own gem, that is, fetcher
     ## see https://github.com/geraldb/fetcher
    
    # nb: in new method src comes first (and dest second - might be optional in the future)
    Fetcher::Worker.new( logger ).copy( src, dest )
  end
  
  
  def fetch_slideshow_templates
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
    end
    
    
    # src = 'http://github.com/geraldb/slideshow/raw/d98e5b02b87ee66485431b1bee8fb6378297bfe4/code/templates/fullerscreen.txt'
    # src = 'http://github.com/geraldb/sandbox/raw/13d4fec0908fbfcc456b74dfe2f88621614b5244/s5blank/s5blank.txt'
    uri = URI.parse( src )
  
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
  
    dirname  = File.dirname( uri.path )    
    basename = File.basename( uri.path, '.*' ) # e.g. fullerscreen     (without extension)
    filename = File.basename( uri.path )       # e.g. fullerscreen.txt (with extension)

    logger.debug "dirname: #{dirname}"
    logger.debug "basename: #{basename}, filename: #{filename}"

    dlbase = "#{uri.scheme}://#{uri.host}:#{uri.port}#{dirname}"
    pkgpath = File.expand_path( "#{config_dir}/templates/#{basename}" )
  
    logger.debug "dlpath: #{dlbase}"
    logger.debug "pkgpath: #{pkgpath}"
  
    FileUtils.makedirs( pkgpath ) unless File.directory? pkgpath 
   
    puts "Fetching template package '#{basename}'"
    puts "  : from '#{dlbase}'"
    puts "  : saving to '#{pkgpath}'"
  
    # download manifest
    dest = "#{pkgpath}/#{filename}"

    puts "  Downloading manifest '#{filename}'..."

    fetch_file( dest, src )

    manifest = load_manifest_core( dest )
      
    # download templates listed in manifest
    manifest.each do |values|
      values[1..-1].each do |file|
      
        dest = "#{pkgpath}/#{file}"

        # make sure path exists
        destpath = File.dirname( dest )
        FileUtils.makedirs( destpath ) unless File.directory? destpath
    
        src = "#{dlbase}/#{file}"
    
        puts "  Downloading template '#{file}'..."
        fetch_file( dest, src )
      end
    end   
    puts "Done."  
  end  


end # class Fetch

end # module Slideshow