# encoding: utf-8

module Slideshow

class List

  include LogUtils::Logging

  include ManifestHelper

### fix: remove opts, use config (wrapped!!)
  
  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config

  def run
    home = Env.home
    ## replace home w/ ~ (to make out more readable (shorter))
    ## e.g. use gsub( home, '~' )

    puts ''
    puts 'Installed plugins in search path'

    installed_plugin_manifest_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    puts '  include:'

    installed_plugin_manifests.each do |manifest|
      pakname      = manifest[0].gsub('.txt','').gsub('.plugin','')
      manifestpath = manifest[1].gsub(home,'~')
      puts "%16s (%s)" % [pakname,manifestpath]
    end

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