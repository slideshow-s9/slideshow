# encoding: utf-8


require 'gli'
 
include GLI::App
 
program_desc 'Slide Show (S9) - a free web alternative to PowerPoint and Keynote'

version Slideshow::VERSION


## some setup code 

LogUtils::Logger.root.level = :info   # set logging level to info 

opts = Slideshow::Opts.new



## "global" options (switches/flags)

desc "(Debug) Show debug messages"   # add --debug as alias? - add -w why? why not?
switch [:verbose]   # NB: using -w as switch not -v (-v is used for version) - why w? who else is using it? ruby interpreter? check

desc "Only show warnings, errors and fatal messages"
switch [:q, :quiet]


desc "Configuration Path (default is #{opts.config_path})"
arg_name 'PATH'
flag [:c, :config]

desc "Template Manifest (default is #{opts.manifest})"
arg_name 'MANIFEST'
flag [:t, :template]



desc 'Build slideshow'
command [:b,:build] do |c|

  c.desc 'Set Header Level to 1 (default)'
  c.switch [:h1]  # todo: add :1 if it works e.g. -1 why? why not??
  
  c.desc 'Set Header Level to 2'
  c.switch [:h2]

  c.desc 'Use only !SLIDE for slide breaks (Showoff Compatible)'
  c.switch [:slide]

  c.desc 'Allow // for slide breaks'
  c.switch [:takahashi]


  c.desc "Output Path (default is #{opts.output_path})"
  c.arg_name 'PATH'
  c.flag [:o,:output]


  c.action do |global_options,options,args|

    puts "hello from build command"
 
  end
end


desc 'List all installed template packs'
command [:l,:ls,:list] do |c|

  c.action do |global_options,options,args|

    puts "hello from list command"

  end
end


desc 'Install (fetch) template pack'
command [:f,:fetch,:i,:install] do |c|

  c.action do |global_options,options,args|

    puts "hello from install/fetch command"

  end
end


command [:q,:quick,:n,:new] do |c|   # quick  - use g,gen,generate? too for templates?

  c.action do |global_options,options,args|

    puts "hello from quick/new command"

  end
end


command [:a,:about,:info] do |c|
  c.action do
    puts "hello from about command"
  end
end


command [:p,:plugin,:plugins] do |c|
  c.action do
    puts "hello from plugin command"
  end
end

command :test do |c|
  c.action do
    puts "hello from test command"
  end
end


exit run(ARGV)