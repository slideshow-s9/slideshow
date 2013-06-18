# encoding: utf-8


require 'gli'


 
include GLI::App
  
 
program_desc 'Slide Show (S9) - a free web alternative to PowerPoint and Keynote in Ruby'

version Slideshow::VERSION


## some setup code 

LogUtils::Logger.root.level = :info   # set logging level to info 

logger = LogUtils::Logger.root

opts    = Slideshow::Opts.new
config  = Slideshow::Config.new( opts )
headers = Slideshow::Headers.new( config )  ##  NB: needed for build - move into build - why? why not?


config.load


## gets all merged in one paragraph - does not honor whitespace
xxx_program_long_desc = <<EOS
         
Slide Show (S9) is a free web alternative to PowerPoint or Keynote in Ruby

Examples:
  slideshow microformats
  slideshow microformats.text            # Process slides using Markdown (#{config.known_markdown_extnames.join(', ')})
  slideshow microformats.textile         # Process slides using Textile (#{config.known_textile_extnames.join(', ')})
  slideshow microformats.rst             # Process slides using reStructuredText (#{config.known_rest_extnames.join(', ')})
  slideshow -o slides microformats       # Output slideshow to slides folder

More examles:
  slideshow -q                           # Generate quickstart slide show sample
  slideshow -g                           # Generate slide show templates using built-in S6 pack

  slideshow -l                           # List installed slide show templates
  slideshow -f s5blank                   # Fetch (install) S5 blank starter template from internet
  slideshow -t s5blank microformats      # Use your own slide show templates (e.g. s5blank)

Further information:
  http://slideshow-s9.github.io

EOS


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
  end
end # class SysInfo



## "global" options (switches/flags)

desc '(Debug) Show debug messages'
switch [:verbose], negatable: false    ## todo: use -w for short form? check ruby interpreter if in use too?

desc 'Only show warnings, errors and fatal messages'
switch [:q, :quiet], negatable: false


desc 'Configuration Path'
arg_name 'PATH'
default_value opts.config_path
flag [:c, :config] 


desc 'Build slideshow'
arg_name 'FILE', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:build, :b] do |c|

  c.desc 'Set Header Level to 1 (default)'
  c.switch [:h1], negatable: false  # todo: add :1 if it works e.g. -1 why? why not??
  
  c.desc 'Set Header Level to 2'
  c.switch [:h2], negatable: false

  c.desc 'Use only !SLIDE for slide breaks (Showoff Compatible)'
  c.switch [:slide], negatable: false

  c.desc 'Allow // for slide breaks'
  c.switch [:takahashi], negatable: false


  c.desc 'Output Path'
  c.arg_name 'PATH'
  c.default_value opts.output_path
  c.flag [:o,:output]

  c.desc 'Template Manifest'
  c.arg_name 'MANIFEST'
  c.default_value opts.manifest
  c.flag [:t, :template]


  c.action do |g,o,args|
    logger.debug 'hello from build command'
    
    PluginLoader.new( config ).load_plugins  # check for optional plugins/extension in ./lib folder

    finder = FileFinder.new( config )

    args.each do |arg|
      files = finder.find_files( arg )
      files.each do |file| 
       ### fix/todo: reset/clean headers
        Slideshow::Gen.new( opts, config, headers ).create_slideshow( file )
      end
    end
 
  end
end


desc 'List installed template packs'
command [:list,:ls,:l] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from list command'
    
    Slideshow::List.new( opts, config ).run   ### todo: remove opts (merge access into config)
  end
end


desc 'Install template pack'
arg_name 'MANIFEST', multiple: true
command [:install,:i] do |c|

  c.desc "Template Packs (#{config.default_fetch_shortcuts.keys.join(', ')})"
  c.switch [:a,:all], negatable: false

  c.action do |g,o,args|
    logger.debug 'hello from install command'
    
    if opts.fetch_all?
      Slideshow::Fetch.new( opts, config ).fetch_all  ## todo: remove opts merge into config
    end
    
    args.each do |arg|
      Slideshow::Fetch.new( opts, config ).fetch( arg )  ## todo: remove opts merge into config
    end
  end
end


arg_name 'MANIFEST', multiple: true, optional: true   ## todo/fix: check optional ignored, multiple too -typo? why?
command [:new,:n] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from new command'

    ## todo: check if args.length = 0
    ##  use quick_manifest (default) otherwise pass along/use args
    Slideshow::Quick.new( opts, config ).run  ### todo: remove opts

  end
end

desc '(Debug) Show more version info'
skips_pre
command [:about,:a] do |c|
  c.action do
    logger.debug 'hello from about command'

    SysInfo.new( config ).dump
  end
end


command [:plugins,:plugin,:p] do |c|
  c.action do
    logger.debug 'hello from plugin command'
  end
end

desc '(Debug) Show global options, options, arguments for test command'
command :test do |c|
  c.action do |g,o,args|
    puts 'hello from test command'
    puts 'g/global_options:'
    pp g
    puts 'o/options:'
    pp o
    puts 'args:'
    pp args
  end
end



pre do |g,c,o,args|
  opts.merge_gli_options!( g )
  opts.merge_gli_options!( o )

  puts Slideshow.generator

  if opts.verbose?
    LogUtils::Logger.root.level = :debug

    # dump Slideshow settings
    config.dump
    puts
      
    # dump Markdown settings
    Markdown.dump
    puts
  end

  logger.debug "Executing #{c.name}"   
  true
end

post do |global,c,o,args|
  logger.debug "Executed #{c.name}"
  true
end


on_error do |e|
  puts
  puts "*** error: #{e.message}"

  ## todo/fix: find a better way to print; just raise exception e.g. raise e  - why? why not??
  puts e.backtrace.inspect  if opts.verbose?
  
  false # skip default error handling
end


exit run(ARGV)