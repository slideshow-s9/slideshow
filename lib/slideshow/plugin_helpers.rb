module Slideshow

module PluginHelper

  def find_plugin_patterns
    patterns = []

    ###
    #  todo/fix: only include rb files listed in plugin manifests!
    #  - for now load all ruby files in plugins folder

    patterns << "#{config.config_dir}/plugins/**/*.rb"

    ######
    # also allow "ad-hoc" plugins e.g. no manifest required (not installed)
    #   just ruby scripts in lib in config folder or working folder

    patterns << "#{config.config_dir}/lib/**/*.rb"

    #########
    #  todo/fix: only include rb files listed in plugin manifest (see above!)

    patterns << 'plugins/**/*.rb'

    patterns << 'lib/**/*.rb' unless Slideshow.root == File.expand_path( '.' )  # don't include lib if we are in repo (don't include slideshow/lib)    
    patterns
  end

  def find_plugins
    patterns = find_plugin_patterns

    plugins=[]
    patterns.each do |pattern|
      pattern.gsub!( '\\', '/')  # normalize path; make sure all path use / only
      Dir.glob( pattern ) do |plugin|
        plugins << plugin
      end
    end
    plugins
  end

  def load_plugins
    patterns = find_plugin_patterns
  
    patterns.each do |pattern|
      pattern.gsub!( '\\', '/')  # normalize path; make sure all path use / only
      Dir.glob( pattern ) do |plugin|
        begin
          ## NB: use full_path - since Ruby 1.9.2 - ./ no longer included in load path for security
          plugin_fullpath = File.expand_path( plugin )  # nb: will use Dir.pwd (e.g. ./) as second arg
          puts "Loading plugins in '#{plugin}' (#{plugin_fullpath})..."
          require( plugin_fullpath )
        rescue Exception => e
          puts "** error: failed loading plugins in '#{plugin}': #{e}"
        end
      end
    end
  end  # method load_plugins


end # module PluginHelper
end # module Slideshow
