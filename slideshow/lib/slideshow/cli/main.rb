# encoding: utf-8

### NOTE: wrap gli config into a class
##  see github.com/davetron5000/gli/issues/153


module Slideshow

  class Tool
     def initialize
       LogUtils::Logger.root.level = :info   # set logging level to info 
     end

     def run( args )
       puts SlideshowCli.banner
       Toolii.run( args )
     end
  end


  class Toolii
    extend GLI::App

   def self.logger=(value) @@logger=value; end
   def self.logger()       @@logger; end

   ## todo: find a better name e.g. change to settings? config? safe_opts? why? why not?
   def self.opts=(value)  @@opts = value; end
   def self.opts()        @@opts; end

   def self.config=(value)  @@config = value; end
   def self.config()        @@config; end


## some setup code 
logger  = LogUtils::Logger.root
opts    = Slideshow::Opts.new 
config  = Slideshow::Config.new( opts )

config.load



program_desc 'Slide Show (S9) - a free web alternative to PowerPoint and Keynote in Ruby'

version SlideshowCli::VERSION


=begin
## gets all merged in one paragraph - does not honor whitespace
xxx_program_long_desc = <<EOS
         
Slide Show (S9) is a free web alternative to PowerPoint or Keynote in Ruby

Examples:
  slideshow microformats.text
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
=end


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

  #  cmd.on( '--header NUM', 'Header Level (default is 1)' ) do |n|
  #    opts.header_level = n.to_i
  #  end


  # ?? opts.on( "-s", "--style STYLE", "Select Stylesheet" ) { |s| $options[:style]=s }
        
  # ?? cmd.on( '-i', '--include PATH', 'Load Path' ) { |s| opts.put( 'include', s ) }


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
    
    ## pass in args array (allow/supports multi files)
    Slideshow::Build.new( config ).create_slideshow( args ) 
  end
end


desc 'List installed template packs'
command [:list,:ls,:l] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from list command'
    
    Slideshow::List.new( config ).run   ### todo: remove opts (merge access into config)
  end
end


desc 'Install template pack'
arg_name 'MANIFEST', multiple: true
command [:install,:i] do |c|

  c.desc "Template Packs (#{config.default_fetch_shortcuts.join(', ')})"
  c.switch [:a,:all], negatable: false

  c.action do |g,o,args|
    logger.debug 'hello from install command'
    
    if opts.fetch_all?
      Slideshow::Fetch.new( config ).fetch_all  ## todo: remove opts merge into config
    end
    
    args.each do |arg|
      Slideshow::Fetch.new( config ).fetch( arg )  ## todo: remove opts merge into config
    end
  end
end


desc "Update shortcut index for template packs 'n' plugins"
command [:update,:u] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from update command'
    
    Slideshow::Update.new( config ).update
  end
end


desc 'Generate quick starter sample'
command [:new,:n] do |c|

  c.desc 'Output Path'
  c.arg_name 'PATH'
  c.default_value opts.output_path
  c.flag [:o,:output]

  c.desc 'Template Manifest'
  c.arg_name 'MANIFEST'
  c.default_value opts.quick_manifest
  c.flag [:t, :template]


  c.action do |g,o,args|
    logger.debug 'hello from new command'

    ##  use quick_manifest (default) otherwise pass along/use args
    Slideshow::Quick.new( config ).run

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

desc '(Debug) List plugin scripts in load path'
command [:plugins,:plugin,:p] do |c|
  c.action do
    logger.debug 'hello from plugin command'

    Slideshow::Plugins.new( config ).run
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
  end

  logger.debug "   executing command #{c.name}"
  true
end

post do |global,c,o,args|
  logger.debug "   executed command #{c.name}"
  true
end


on_error do |e|
  puts
  puts "*** error: #{e.message}"
  puts

  ## todo/fix: find a better way to print; just raise exception e.g. raise e  - why? why not??
  ## puts e.backtrace.inspect  if opts.verbose?
  raise e   if opts.verbose?

  false # skip default error handling
end


#### exit run(ARGV)   ## note: use Toolii.run( ARGV ) outside of class

  end  # class Toolii
end  # module Slideshow
