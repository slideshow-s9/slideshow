module Slideshow

class GenTemplates

  include Manifest   # gets us methods like installed_template_manifests, etc.

### fix: remove opts, use config (wrapped!!)

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config



  def with_output_path( dest, output_path )
    dest_full = File.expand_path( dest, output_path )
    logger.debug "dest_full=#{dest_full}"
      
    # make sure dest path exists
    dest_path = File.dirname( dest_full )
    logger.debug "dest_path=#{dest_path}"
    FileUtils.makedirs( dest_path ) unless File.directory? dest_path
    dest_full
  end


  def run
    manifest_name = opts.manifest
    logger.debug "manifest=#{manifest_name}"
    
    manifests = installed_generator_manifests
    
    # check for builtin generator manifests
    matches = manifests.select { |m| m[0] == manifest_name+".gen" }
    
    if matches.empty?
      puts "*** error: unknown template manifest '#{manifest_name}'"
      # todo: list installed manifests
      exit 2
    end
        
    manifest = load_manifest( matches[0][1] )

    # expand output path in current dir and make sure output path exists
    outpath = File.expand_path( opts.output_path ) 
    logger.debug "outpath=#{outpath}"
    FileUtils.makedirs( outpath ) unless File.directory? outpath

    manifest.each do |entry|
      dest   = entry[0]
      source = entry[1]
                  
      puts "Copying to #{dest} from #{source}..."
      FileUtils.copy( source, with_output_path( dest, outpath ) )
    end
    
    puts "Done."
  end

end # class GenTemplates

end # class Slideshow