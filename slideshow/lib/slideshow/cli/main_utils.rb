# encoding: utf-8


class PluginLoader
  include LogUtils::Logging
  include Slideshow::PluginHelper  # e.g. gets us load_plugins machinery

  def initialize( config )
    @config = config
  end

  attr_reader :config
end


class SysInfo
  def initialize( config )
    @config = config
  end
  
  attr_reader :config
  
  def dump
  puts <<EOS

#{Slideshow.generator}

Gems versions:
  - pakman #{Pakman::VERSION}
  - fetcher #{Fetcher::VERSION}
  - kramdown #{Kramdown::VERSION}
  - textutils #{TextUtils::VERSION}
  - logutils #{LogKernel::VERSION}
  - props #{Props::VERSION}

  - slideshow-models #{Slideshow::VERSION}
  - slideshow-templates #{SlideshowTemplates::VERSION}
  - slideshow #{SlideshowCli::VERSION}

                 Env home: #{Env.home}
         Slideshow config: #{config.config_dir}
          Slideshow cache: #{config.cache_dir}
           Slideshow root: #{Slideshow.root}
  SlideshowTemplates root: #{SlideshowTemplates.root}

EOS

  # dump Slideshow settings
  config.dump
  puts
      
  # todo:
  # add version for rubygems

      
    dump_load_path   # helps debugging pluggin loading (e.g. Ruby 1.9.2> no longer includes ./ in load path)
  end

  def dump_load_path
    puts 'load path:'
    $LOAD_PATH.each_with_index do |path,i|
      puts "  [#{i+1}] #{path}"
    end
  end

end # class SysInfo
