module Slideshow

class GenTemplates
  
  include Manifest

### fix: remove opts, use config (wrapped!!)

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config

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
        
    manifestsrc = matches[0][1]
    pakpath     = opts.output_path
    
    Pakman::Copier.new( logger ).copy_pak( manifestsrc, pakpath )
  end

end # class GenTemplates
end # module Slideshow