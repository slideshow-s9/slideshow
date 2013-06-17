# encoding: utf-8


require 'gli'
 
include GLI::App
 
program_desc 'Slide Show (S9) - a free web alternative to PowerPoint and Keynote'

version Slideshow::VERSION


## some setup code 

LogUtils::Logger.root.level = :info   # set logging level to info 

logger = LogUtils::Logger.root

opts    = Slideshow::Opts.new
config  = Slideshow::Config.new( opts )
## headers = Headers.new( config )   --needed ???
 

config.load


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
end



## "global" options (switches/flags)

desc "(Debug) Show debug messages"   # add --debug as alias? - add -w why? why not?
switch [:verbose], negatable: false   # NB: using -w as switch not -v (-v is used for version) - why w? who else is using it? ruby interpreter? check

desc "Only show warnings, errors and fatal messages"
switch [:q, :quiet], negatable: false


desc "Configuration Path"
arg_name 'PATH'
default_value opts.config_path
flag [:c, :config] 

desc "Template Manifest"
arg_name 'MANIFEST'
default_value opts.manifest
flag [:t, :template]



desc 'Build slideshow'
command [:build, :b] do |c|

  c.desc 'Set Header Level to 1 (default)'
  c.switch [:h1], negatable: false  # todo: add :1 if it works e.g. -1 why? why not??
  
  c.desc 'Set Header Level to 2'
  c.switch [:h2], negatable: false

  c.desc 'Use only !SLIDE for slide breaks (Showoff Compatible)'
  c.switch [:slide], negatable: false

  c.desc 'Allow // for slide breaks'
  c.switch [:takahashi], negatable: false


  c.desc "Output Path"
  c.arg_name 'PATH'
  c.default_value opts.output_path
  c.flag [:o,:output]


  c.action do |g,o,args|

    puts "hello from build command"
 
  end
end


desc 'List all installed template packs'
command [:list,:ls,:l] do |c|

  c.action do |g,o,args|
    logger.debug "hello from list command"
    
    Slideshow::List.new( opts, config ).run   ### todo: remove opts (merge access into config)
  end
end


desc 'Install (fetch) template pack'
command [:install,:i,:fetch,:f] do |c|

  ## todo: add -a/--all switch

  c.action do |g,o,args|
    logger.debug "hello from install/fetch command"
    
    ## fix: template to fetch missing
    Slideshow::Fetch.new( opts, config ).run  ### todo: remove opts
  end
end


command [:new,:n,:quick,:q] do |c|   # quick  - use g,gen,generate? too for templates?

  c.action do |g,o,args|

    puts "hello from quick/new command"

  end
end

desc '(Debug) Show more version info'
skips_pre
command [:about,:a,:info] do |c|
  c.action do
    logger.debug "hello from about command"

    SysInfo.new( config ).dump

  end
end


command [:plugins,:plugin,:p] do |c|
  c.action do
    logger.debug "hello from plugin command"
  end
end

desc '(Debug) Show global options, options, arguments for command'
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



pre do |global,c,o,args|
  if global[:verbose]
    LogUtils::Logger.root.level = :debug
  end
  
  ## todo: merge all global and local options into our own options class
  
  puts Slideshow.generator

  if opts.verbose?
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
end


on_error do |exception|
  puts
  puts "*** error:"
  
  raise exception  # todo: add return false ??? to get stack trace??
  # Error logic here
  # return false to skip default error handling
  true
end



exit run(ARGV)