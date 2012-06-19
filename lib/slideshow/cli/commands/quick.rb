module Slideshow

class Quick

### fix: remove opts, use config (wrapped!!)

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config

  def run
    manifest_name = opts.quick_manifest
    
    ### todo:fix: always download quickstart templates (except welcome?)
    # how to make sure the won't go stale in the cache after the download?
    
    manifests = installed_quick_manifests
    matches = manifests.select { |m| m[0] == manifest_name+'.txt.quick' }

    if matches.empty?
      fetch_pak( manifest_name ) 
      
      # retry
      manifests = installed_quick_manifests
      matches = manifests.select { |m| m[0] == manifest_name+'.txt.quick' }
      if matches.empty?
        puts "*** error: quickstart template #{manifest_name} not found"
        exit 2
      end
    end
    
    manifestsrc = matches[0][1]
    pakpath     = opts.output_path
 
    logger.debug( "manifestsrc=>#{manifestsrc}<, pakpath=>#{pakpath}<" )
    
    Pakman::Copier.new( logger ).copy_pak( manifestsrc, pakpath )
  end
  
  
  def fetch_pak( shortcut )

    src = config.map_quick_shortcut( shortcut )
      
    if src.nil?
      puts "*** error: no mapping found for quick shortcut '#{shortcut}'."
      exit 2
    end
    
    puts "  Mapping quick shortcut '#{shortcut}' to: #{src}"
  
 
    # src = 'http://github.com/geraldb/slideshow/raw/d98e5b02b87ee66485431b1bee8fb6378297bfe4/code/templates/fullerscreen.txt'
    # src = 'http://github.com/geraldb/sandbox/raw/13d4fec0908fbfcc456b74dfe2f88621614b5244/s5blank/s5blank.txt'
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"
    
    basename = File.basename( uri.path, '.*' ) # e.g. fullerscreen     (without extension)
    logger.debug "basename: #{basename}"  

     #### fix: in find manifests
     ## check for directories!!!
     ## exclude directories in match

     
     ## remove (.txt) in basename
    pakpath = File.expand_path( "#{config.config_dir}/quick/#{basename.gsub('.txt','')}.quick" )
    logger.debug "pakpath: #{pakpath}"

 
    Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
  end # method fetch_pak

private


  def installed_quick_manifests
   # 1) search config_dir/templates
   # 2) search gem/templates 
 
    builtin_patterns = [
      "#{Slideshow.root}/templates/*.txt.quick"
    ]
    config_patterns  = [
      "#{config.config_dir}/quick/*.txt.quick",
      "#{config.config_dir}/quick/*/*.txt.quick"
    ]
    
    patterns = []
    patterns += config_patterns
    patterns += builtin_patterns

    Pakman::Finder.new( logger ).find_manifests( patterns )
  end

end # class GenTemplates
end # module Slideshow