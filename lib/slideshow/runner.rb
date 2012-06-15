module Slideshow

class Runner

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @opts    = Opts.new
    @config  = Config.new( @logger, @opts )
    @headers = Headers.new( @config )
  end

  attr_reader :logger, :opts, :config, :headers



def load_plugins
    
  patterns = []
  patterns << "#{config_dir}/lib/**/*.rb"
  patterns << 'lib/**/*.rb' unless Slideshow.root == File.expand_path( '.' )  # don't include lib if we are in repo (don't include slideshow/lib)
  
  patterns.each do |pattern|
    pattern.gsub!( '\\', '/')  # normalize path; make sure all path use / only
    Dir.glob( pattern ) do |plugin|
      begin
        puts "Loading plugins in '#{plugin}'..."
        require( plugin )
      rescue Exception => e
        puts "** error: failed loading plugins in '#{plugin}': #{e}"
      end
    end
  end
end


def run( args )

  opt=OptionParser.new do |cmd|
    
    cmd.banner = "Usage: slideshow [options] name"
    
    cmd.on( '-o', '--output PATH', 'Output Path' ) { |path| opts.output_path = path }

    cmd.on( '-g', '--generate',  'Generate Slide Show Templates (Using Built-In S6 Pack)' ) { opts.generate = true }
    
    cmd.on( "-t", "--template MANIFEST", "Template Manifest" ) do |t|
      # todo: do some checks on passed in template argument
      opts.manifest = t
    end

    # ?? opts.on( "-s", "--style STYLE", "Select Stylesheet" ) { |s| $options[:style]=s }
    # ?? opts.on( "--version", "Show version" )  {}
        
    # ?? cmd.on( '-i', '--include PATH', 'Load Path' ) { |s| opts.put( 'include', s ) }

    cmd.on( '-f', '--fetch URI', 'Fetch Templates' ) do |uri|
      opts.fetch_uri = uri
    end
    
    cmd.on( '-c', '--config PATH', 'Configuration Path (default is ~/.slideshow)' ) do |path|
      opts.config_path = path
    end
    
    cmd.on( '-l', '--list', 'List Installed Templates' ) { opts.list = true }

    # todo: find different letter for debug trace switch (use v for version?)
    cmd.on( "-v", "--verbose", "Show debug trace" )  do
       logger.datetime_format = "%H:%H:%S"
       logger.level = Logger::DEBUG      
    end
 
    usage =<<EOS

Slide Show (S9) is a free web alternative to PowerPoint or KeyNote in Ruby

#{cmd.help}

Examples:
  slideshow microformats
  slideshow microformats.textile         # Process slides using Textile
  slideshow microformats.text            # Process slides using Markdown
  slideshow microformats.rst             # Process slides using reStructuredText
  slideshow -o slides microformats       # Output slideshow to slides folder

More examles:
  slideshow -g                           # Generate slide show templates using built-in S6 pack

  slideshow -l                           # List installed slide show templates
  slideshow -f s5blank                   # Fetch (install) S5 blank starter template from internet
  slideshow -t s5blank microformats      # Use your own slide show templates (e.g. s5blank)

Further information:
  http://slideshow.rubyforge.org
  
EOS
 
 
    cmd.on_tail( "-h", "--help", "Show this message" ) do
         puts usage
         exit
    end
  end

  opt.parse!( args )
  
  config.load

  puts Slideshow.generator

  if opts.list?
    List.new( logger, opts, config, headers ).list_slideshow_templates   ### use run; remove headers/opts
  elsif opts.generate?
    GenTemplates.new( logger, opts, config, headers ).create_slideshow_templates  ### use run; remove headers/opts
  elsif opts.fetch?
    Fetch.new( logger, opts, config, headers ).fetch_slideshow_templates  ### use run; remove headers/opts
  else
    load_plugins  # check for optional plugins/extension in ./lib folder

    args.each do |fn|
      Gen.new( logger, opts, config, headers ).create_slideshow( fn )
    end
  end
end


end # class Runner

end # module Slideshow