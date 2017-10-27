# encoding: utf-8


module Slideshow

module ManifestHelper

  ## shared methods for handling manifest lookups

  def installed_plugin_manifest_patterns
    # 1) search ./plugins
    # 2) search config_dir/plugins

    config_patterns  = [
      "#{config.config_dir}/plugins/*.{txt.plugin,plugin.txt}",
      "#{config.config_dir}/plugins/*/*.{txt.plugin,plugin.txt}"
    ]
    current_patterns = [
      "plugins/*.{txt.plugin,plugin.txt}",
      "plugins/*/*.{txt.plugin,plugin.txt}"
    ]

    patterns = []
    patterns += current_patterns
    patterns += config_patterns
  end

  def installed_plugin_manifests  # quickstarter templates
    Pakman::Finder.new.find_manifests( installed_plugin_manifest_patterns )
  end


  def installed_template_manifest_patterns
    # 1) search ./templates
    # 2) search config_dir/templates
    # 3) search gem/templates

    test_patterns = []
    test_patterns << "#{Slideshow.root}/test/templates/*/*.txt"

    config_patterns  = [
      "#{config.config_dir}/templates/*.txt",
      "#{config.config_dir}/templates/*/*.txt"
    ]
    current_patterns = [
      "templates/*.txt",
      "templates/*/*.txt",     # todo: use all in one line? {*.txt,*/*.txt} does it work?
      "node_modules/*/*.txt",  # note: add support for npm installs - use/make slideshow required in name? for namespace in the future???
    ]

    patterns = []
    patterns += current_patterns
    patterns += test_patterns      if config.test?    ## (auto-)add test templates in test mode
    patterns += config_patterns
  end

  def installed_template_manifests
    ## note: code moved to its own gem, that is, pakman
    ## see https://github.com/geraldb/pakman

    ## exclude manifest.txt/i  (avoid confusion w/ ruby gem manifest; not a specific name anyway)
    ##  also exclude patterns for quickstarter templates

    excludes = [
      'manifest.txt',
      '*/manifest.txt',
      '*.{txt.quick,quick.txt}',
      '*/*.{txt.quick,quick.txt}'
    ]

    Pakman::Finder.new.find_manifests( installed_template_manifest_patterns, excludes )
  end


  def installed_quick_manifest_patterns
    # 1) search config_dir/templates
    # 2) search gem/templates

    # Note: only include builtin patterns if slideshow-templates gem included/required (it's optional)
    builtin_patterns = []
    builtin_patterns << "#{Slideshow.root}/templates/*.{txt.quick,quick.txt}"

    config_patterns  = [
      "#{config.config_dir}/templates/*.{txt.quick,quick.txt}",
      "#{config.config_dir}/templates/*/*.{txt.quick,quick.txt}"
    ]

    current_patterns = [
      "node_modules/*/*.{txt.quick,quick.txt}",  # note: add support for npm installs - use/make slideshow required in name? for namespace in the future???
    ]

    patterns = []
    patterns += current_patterns
    patterns += config_patterns
    patterns += builtin_patterns
  end

  def installed_quick_manifests  # quickstarter templates
    Pakman::Finder.new.find_manifests( installed_quick_manifest_patterns )
  end


end # module Manifest
end # module Slideshow
