# encoding: utf-8


LogUtils::Logger.root.level = :info   # set logging level to info 


require 'gli'
 
include GLI::App
 
program_desc 'Slide Show (S9) - a free web alternative to PowerPoint and Keynote'

##
## -t/--template  ??
## -c/--config-dir ??


global_option '-i', '--include PATH', String, "Data path (default is #{myopts.data_path})"
global_option '-d', '--dbpath PATH', String, "Database path (default is #{myopts.db_path})"
global_option '-n', '--dbname NAME', String, "Database name (datault is #{myopts.db_name})"

global_option '-q', '--quiet', "Only show warnings, errors and fatal messages"
### todo/fix: just want --debug/--verbose flag (no single letter option wanted) - fix
global_option '-w', '--verbose', "Show debug messages"



desc 'Build slideshow'
command [:b,:build] do |c|

  c.desc 'Verbose/Debug'
  c.switch :verbose


#    cmd.on( '--h1', 'Set Header Level to 1 (default)' ) { opts.header_level = 1 }
#    cmd.on( '--h2', 'Set Header Level to 2' ) { opts.header_level = 2 }
#
#    cmd.on( '--slide', 'Use only !SLIDE for slide breaks (Showoff Compatible)' ) do
#      opts.slide = true
#    end
#
#    cmd.on( '--takahashi', 'Allow // for slide breaks' ) do
#      opts.takahashi = true
#    end


  c.desc 'Config Folder'
  c.default_value "tbd"  # use opts.template ??
  c.flag [:c,:config]

  c.desc 'Output Folder'
  c.default_value "tbd"  # use opts.template ??
  c.flag [:o,:output]

  c.desc 'Template'
  c.default_value "tbd"  # use opts.template ??
  c.flag [:t,:template]

  c.action do |global_options,options,args|

    load_plugins  # check for optional plugins/extension in ./lib folder

    args.each do |arg|
      files = find_files( arg )
      files.each do |file| 
        ### fix/todo: reset/clean headers
        Gen.new( opts, config, headers ).create_slideshow( file )
      end
    end
 
  end
end


command [:l,:ls,:list] do |c|
  c.desc 'List all installed template packs'
  c.action do |global_options,options,args|
    
    List.new( opts, config ).run   ### todo: remove opts (merge access into config)

  end
end


command [:f,:fetch,:i,:install] do |c|
  c.desc 'Install/fetch template pack'
  c.action do |global_options,options,args|

    Fetch.new( opts, config ).run  ### todo: remove opts

  end
end


command [:q,:quick,:n,:new] do |c|   # quick  - use g,gen,generate? too for templates?
  c.action do |global_options,options,args|

    ## if opts.quick?
    Quick.new( opts, config ).run  ### todo: remove opts

    ## if opts.generate?
    GenTemplates.new( opts, config ).run  ###  todo: remove opts

  end
end


command [:a,:about,:info] do |c|
  c.action do
    # do something here
  end
end


command [:p,:plugin,:plugins] do |c|
  c.action do
    # if opts.plugins?
    Plugins.new( opts, config ).run  ### todo: remove opts (merge access into config)
  end
end
