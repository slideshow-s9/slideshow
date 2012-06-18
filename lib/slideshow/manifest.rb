module Slideshow
  module Manifest

  ## shared methods for handling manifest lookups

  def installed_generator_manifests
    # 1) search gem/templates 

    builtin_patterns = [
      "#{Slideshow.root}/templates/*.txt.gen"
    ]

    ## note: code moved to its own gem, that is, pakman
    ## see https://github.com/geraldb/pakman

    Pakman::Finder.new( logger ).find_manifests( builtin_patterns )
  end
  
  def installed_template_manifests
    # 1) search ./templates
    # 2) search config_dir/templates
    # 3) search gem/templates

    builtin_patterns = [
      "#{Slideshow.root}/templates/*.txt"
    ]
    config_patterns  = [
      "#{config.config_dir}/templates/*.txt",
      "#{config.config_dir}/templates/*/*.txt"
    ]
    current_patterns = [
      "templates/*.txt",
      "templates/*/*.txt"
    ]
    
    patterns = []
    patterns += current_patterns  unless Slideshow.root == File.expand_path( '.' )  # don't include working dir if we test code from repo (don't include slideshow/templates)
    patterns += config_patterns
    patterns += builtin_patterns


    ## note: code moved to its own gem, that is, pakman
    ## see https://github.com/geraldb/pakman
  
    Pakman::Finder.new( logger ).find_manifests( patterns )
  end
    
  end # module  Manifest
end # module Slideshow