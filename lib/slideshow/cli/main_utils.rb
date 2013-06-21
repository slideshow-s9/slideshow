# encoding: utf-8

class PluginLoader
  include LogUtils::Logging
  include Slideshow::PluginHelper  # e.g. gets us load_plugins machinery

  def initialize( config )
    @config = config
  end

  attr_reader :config
end


class FileFinder
  include LogUtils::Logging

  def initialize( config )
    @config = config
  end
  
  attr_reader :config

  def find_file_with_known_extension( fn )
    dirname  = File.dirname( fn )
    basename = File.basename( fn, '.*' )
    extname  = File.extname( fn )
    logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

    config.known_extnames.each do |e|
      newname = File.join( dirname, "#{basename}#{e}" )
      logger.debug "File.exists? #{newname}"
      return newname if File.exists?( newname )
    end  # each extension (e)
      
    nil   # not found; return nil
  end


  def find_files( file_or_dir_or_pattern )
    filtered_files = []
 
    ## for now process/assume only single file
    
    ## (check for missing extension)
    if File.exists?( file_or_dir_or_pattern )
      file = file_or_dir_or_pattern
      logger.debug "  adding file '#{file}'..."
      filtered_files << file
    else  # check for existing file w/ missing extension
      file = find_file_with_known_extension( file_or_dir_or_pattern )
      if file.nil?
        puts "  skipping missing file '#{file_or_dir_or_pattern}{#{config.known_extnames.join(',')}}'..."
      else
        logger.debug "  adding file '#{file}'..."
        filtered_files << file
      end
    end
    
    filtered_files 
  end # method find_files
end # class FileFinder


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
  - markdown #{Markdown::VERSION}
  - textutils #{TextUtils::VERSION}
  - props #{Props::VERSION}

        Env home: #{Env.home}
Slideshow config: #{config.config_dir}
 Slideshow cache: #{config.cache_dir}
  Slideshow root: #{Slideshow.root}

EOS

  # dump Slideshow settings
  config.dump
  puts
      
  # dump Markdown settings
  Markdown.dump
  puts

  # todo:
  # add verison for rubygems

  ## todo: add more gem version info
  #- redcloth
  #- kramdown

      
    dump_load_path   # helps debugging pluggin loading (e.g. Ruby 1.9.2> no longer includes ./ in load path)
  end

  def dump_load_path
    puts 'load path:'
    $LOAD_PATH.each_with_index do |path,i|
      puts "  [#{i+1}] #{path}"
    end
  end

end # class SysInfo
