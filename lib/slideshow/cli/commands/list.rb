module Slideshow

class List

  include ManifestHelper

### fix: remove opts, use config (wrapped!!)
  
  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config

  def run
    manifests = installed_template_manifests
    
    puts ''
    puts 'Installed template packs in search path'
    
    installed_template_manifest_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern}"
    end
    puts '  include:'
    
    manifests.each do |manifest|
      puts "%16s (%s)" % [manifest[0], manifest[1]]
    end
  end

end # class List

end # class Slideshow