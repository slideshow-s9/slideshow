module Slideshow

class Plugins

  include LogUtils::Logging

  include PluginHelper

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
    puts 'Plugin scripts on the load path'
    
    find_plugin_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    puts '  include:'

    plugins = find_plugins
    if plugins.empty?
      puts "    -- none --"
    else
      plugins.each do |plugin|
        ## NB: use full_path - since Ruby 1.9.2 - ./ no longer included in load path for security
        plugin_fullpath = File.expand_path( plugin )
        puts "    #{plugin.gsub(home,'~')} (#{plugin_fullpath})"
      end
    end
  end

end # class Plugins
end # module Slideshow