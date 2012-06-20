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
    home = Env.home
    ## replace home w/ ~ (to make out more readable (shorter))
    ## e.g. use gsub( home, '~' )
    
    puts ''
    puts 'Installed quickstarter packs in search path'

    installed_quick_manifest_patterns.each_with_index do |pattern,i|      
      puts "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    puts '  include:'
    
    installed_quick_manifests.each do |manifest|
      pakname      = manifest[0].gsub('.txt','').gsub('.quick','')
      manifestpath = manifest[1].gsub(home,'~')
      puts "%16s (%s)" % [pakname,manifestpath]
    end


    puts ''
    puts 'Installed template packs in search path'
    
    installed_template_manifest_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    puts '  include:'
    
    installed_template_manifests.each do |manifest|
      pakname      = manifest[0].gsub('.txt','')
      manifestpath = manifest[1].gsub(home,'~')
      puts "%16s (%s)" % [pakname,manifestpath]
    end
    
  end

end # class List

end # class Slideshow