module Slideshow

class Quick

  include ManifestHelper

### fix: remove opts, use config (wrapped!!)

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config

  def run
    manifest_name = opts.quick_manifest.gsub('.txt','').gsub('.quick','')  # make sure we get name w/o .quick and .txt extension
    
    ### todo:fix: always download quickstart templates (except welcome?)
    # how to make sure the won't go stale in the cache after the download?
    
    manifests = installed_quick_manifests
    matches = manifests.select { |m| (m[0] == manifest_name+'.txt.quick') || (m[0] == manifest_name+'.quick.txt') }

    if matches.empty?
      fetch_pak( manifest_name )
      
      # retry
      manifests = installed_quick_manifests
      matches = manifests.select { |m| (m[0] == manifest_name+'.txt.quick') || (m[0] == manifest_name+'.quick.txt') }
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
  
  ## todo rename to fetch_quick_pak??
  ##  share/use same code in fetch too??
  
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
    
    pakname = File.basename( uri.path ).downcase.gsub('.txt','')
    pakpath = File.expand_path( "#{config.config_dir}/templates/#{pakname}" )
    
    logger.debug "pakname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
 
    Pakman::Fetcher.new( logger ).fetch_pak( src, pakpath )
  end # method fetch_pak

end # class GenTemplates
end # module Slideshow