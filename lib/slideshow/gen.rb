module Slideshow

class Gen
  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @opts   = Opts.new
    @config = Config.new
  end

  attr_reader :logger, :opts, :config
  attr_reader :session      # give helpers/plugins a session-like hash
  
  def headers
    # give access to helpers to opts with a different name
    @opts
  end

  attr_reader :markup_type  # :textile, :markdown, :rest
  
  # uses configured markup processor (textile,markdown,rest) to generate html
  def text_to_html( content )
    content = case @markup_type
      when :markdown
        markdown_to_html( content )
      when :textile
        textile_to_html( content )
      when :rest
        rest_to_html( content )
    end
    content
  end
 
  def guard_text( text )
    # todo/fix 2: note for Textile we need to differentiate between blocks and inline
    #   thus, to avoid runs - use guard_block (add a leading newline to avoid getting include in block that goes before)
    
    # todo/fix: remove wrap_markup; replace w/ guard_text
    #   why: text might be css, js, not just html      
    wrap_markup( text )
  end
   
  def guard_block( text )
    if markup_type == :textile
      # saveguard with notextile wrapper etc./no further processing needed
      # note: add leading newlines to avoid block-runons
      "\n\n<notextile>\n#{text}\n</notextile>\n"
    else
      text
    end    
  end
  
  def guard_inline( text )
    wrap_markup( text )
  end
  
   
  def wrap_markup( text )    
    if markup_type == :textile
      # saveguard with notextile wrapper etc./no further processing needed
      "<notextile>\n#{text}\n</notextile>"
    else
      text
    end
  end
    
  # todo/fix: move to Config class  
  def cache_dir
    RUBY_PLATFORM =~ /win32/ ? win32_cache_dir : File.join(File.expand_path("~"), ".slideshow")
  end

  # todo/fix: move to Config class  
  def win32_cache_dir
    unless ENV['HOMEDRIVE'] && ENV['HOMEPATH'] && File.exists?(home = ENV['HOMEDRIVE'] + ENV['HOMEPATH'])
      puts "No HOMEDRIVE or HOMEPATH environment variable.  Set one to save a" +
           "local cache of stylesheets for syntax highlighting and more."
      return false
    else
      return File.join(home, '.slideshow')
    end
  end
  
  # todo/fix: move to Config class    
  def config_dir
    unless @config_dir  # first time? calculate config_dir value to "cache"
      
      if opts.config_path
        @config_dir = opts.config_path
      else
        @config_dir = cache_dir
      end
    
      # make sure path exists
      FileUtils.makedirs( @config_dir ) unless File.directory? @config_dir
    end
    
    @config_dir
  end


  def load_template( path ) 
    puts "  Loading template #{path}..."
    return File.read( path )
  end
  
  def render_template( content, the_binding )
    ERB.new( content ).result( the_binding )
  end

  
  def with_output_path( dest, output_path )
    dest_full = File.expand_path( dest, output_path )
    logger.debug "dest_full=#{dest_full}"
      
    # make sure dest path exists
    dest_path = File.dirname( dest_full )
    logger.debug "dest_path=#{dest_path}"
    FileUtils.makedirs( dest_path ) unless File.directory? dest_path
    dest_full
  end
  
  
  def create_slideshow_templates
    
    manifest_name = opts.manifest 
    logger.debug "manifest=#{manifest_name}"
    
    manifests = installed_generator_manifests
    
    # check for builtin generator manifests
    matches = manifests.select { |m| m[0] == manifest_name+".gen" }
    
    if matches.empty?
      puts "*** error: unknown template manifest '#{manifest_name}'"  
      # todo: list installed manifests
      exit 2
    end
        
    manifest = load_manifest( matches[0][1] )

    # expand output path in current dir and make sure output path exists
    outpath = File.expand_path( opts.output_path ) 
    logger.debug "outpath=#{outpath}"
    FileUtils.makedirs( outpath ) unless File.directory? outpath 

    manifest.each do |entry|
      dest   = entry[0]      
      source = entry[1]
                  
      puts "Copying to #{dest} from #{source}..."     
      FileUtils.copy( source, with_output_path( dest, outpath ) )
    end
    
    puts "Done."   
  end
  
  def list_slideshow_templates
    manifests = installed_template_manifests
    
    puts ''
    puts 'Installed templates include:'
    
    manifests.each do |manifest|
      puts "  #{manifest[0]} (#{manifest[1]})"
    end
  end

  # move into a filter??
  def post_processing_slides( content )
    
    # 1) add slide break  
  
    if (@markup_type == :markdown && @markdown_libs.first == 'pandoc-ruby') || @markup_type == :rest
      content = add_slide_directive_before_div_h1( content )
    else
      content = add_slide_directive_before_h1( content )
    end

    dump_content_to_file_debug_html( content )

    # 2) use generic slide break processing instruction to
    #   split content into slides

    slide_counter = 0

    slides       = []
    slide_source = ""
     
    content.each_line do |line|
       if line.include?( '<!-- _S9SLIDE_' )  then
          if slide_counter > 0 then   # found start of new slide (and, thus, end of last slide)
            slides   << slide_source  # add slide to slide stack
            slide_source = ""         # reset slide source buffer
          end
          slide_counter += 1
       end
       slide_source  << line
    end
  
    if slide_counter > 0 then
      slides   << slide_source     # add slide to slide stack
      slide_source = ""            # reset slide source buffer 
    end


    ## split slide source into header (optional) and content/body
    ## plus check for (css style) classes and data attributes

    slides2 = []
    slides.each do |slide_source|
      slide = Slide.new

      ## check for css style classes
      from = 0
      while (pos = slide_source.index( /<!-- _S9(SLIDE|STYLE)_(.*?)-->/m, from ))
        logger.debug "  adding css classes from pi #{$1.downcase}: #{$2.strip}"

        from = Regexp.last_match.end(0)  # continue search later from here
        
        values = $2.strip.dup
        
        # remove data values (eg. x=-20 scale=4) and store in data hash
        values.gsub!( /([-\w]+)[ \t]*=[ \t]*([-\w\.]+)/ ) do |_|
          logger.debug "    adding data pair: key=>#{$1.downcase}< value=>#{$2}<"
          slide.data[ $1.downcase.dup ] = $2.dup
          " "  # replace w/ space
        end
        
        values.strip!  # remove spaces  # todo: use squish or similar and check for empty string
                
        if slide.classes.nil?
          slide.classes = values
        else
          slide.classes << " #{values}"
        end
      end
       
       # try to cut off header using non-greedy .+? pattern; tip test regex online at rubular.com
       #  note/fix: needs to get improved to also handle case for h1 wrapped into div
       #    (e.g. extract h1 - do not assume it starts slide source)
      if slide_source =~ /^\s*(<h1.*?>.*?<\/h\d>)\s*(.*)/m 
        slide.header  = $1
        slide.content = ($2 ? $2 : "")
        logger.debug "  adding slide with header:\n#{slide.header}"
      else
        slide.content = slide_source
        logger.debug "  adding slide with *no* header:\n#{slide.content}"
      end
      slides2 << slide
    end

     # for convenience create a string w/ all in-one-html
     #  no need to wrap slides in divs etc.
   
     content2 = ""
     slides2.each do |slide|         
        content2 << slide.to_classic_html
     end
   
    # make content2 and slide2 available to erb template
    # -- todo: cleanup variable names and use attr_readers for content and slide
  
    @slides   = slides2     # strutured content 
    @content  = content2   # content all-in-one    
  end


  def create_slideshow( fn )

    manifest_path_or_name = opts.manifest
    
    # add .txt file extension if missing (for convenience)
    manifest_path_or_name << ".txt"   if File.extname( manifest_path_or_name ).empty?

  
    logger.debug "manifest=#{manifest_path_or_name}"
    
    # check if file exists (if yes use custom template package!) - allows you to override builtin package with same name 
    if File.exists?( manifest_path_or_name )
      manifest = load_manifest( manifest_path_or_name )
    else
      # check for builtin manifests
      manifests = installed_template_manifests
      matches = manifests.select { |m| m[0] == manifest_path_or_name } 

      if matches.empty?
        puts "*** error: unknown template manifest '#{manifest_path_or_name}'"  
        # todo: list installed manifests
        exit 2
      end
        
      manifest = load_manifest( matches[0][1] )
    end
  
    # expand output path in current dir and make sure output path exists
    outpath = File.expand_path( opts.output_path ) 
    logger.debug "outpath=#{outpath}"
    FileUtils.makedirs( outpath ) unless File.directory? outpath 

    dirname  = File.dirname( fn )    
    basename = File.basename( fn, '.*' )
    extname  = File.extname( fn )
    logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

    # change working dir to sourcefile dir
    # todo: add a -c option to commandline? to let you set cwd?
    
    newcwd  = File.expand_path( dirname )
    oldcwd  = File.expand_path( Dir.pwd )
    
    unless newcwd == oldcwd then
      logger.debug "oldcwd=#{oldcwd}"
      logger.debug "newcwd=#{newcwd}"
      Dir.chdir newcwd
    end  

    puts "Preparing slideshow '#{basename}'..."
                
  if extname.empty? then
    extname  = ".textile"   # default to .textile 
    
    config.known_extnames.each do |e|
       logger.debug "File.exists? #{dirname}/#{basename}#{e}"
       if File.exists?( "#{dirname}/#{basename}#{e}" ) then         
          extname = e
          logger.debug "extname=#{extname}"
          break
       end
    end     
  end

  if config.known_markdown_extnames.include?( extname )
    @markup_type = :markdown
  elsif config.known_rest_extnames.include?( extname )
    @markup_type = :rest
  else
    @markup_type = :textile
  end
  
  # shared variables for templates (binding)
  @content_for = {}  # reset content_for hash

  @name        = basename
  @extname     = extname

  @headers     = @opts  # deprecate/remove: use headers method in template

  @session     = {}  # reset session hash for plugins/helpers

  inname  =  "#{dirname}/#{basename}#{extname}"

  logger.debug "inname=#{inname}"
    
  content = File.read( inname )

  # run text filters
  
  config.text_filters.each do |filter|
    mn = filter.tr( '-', '_' ).to_sym  # construct method name (mn)
    content = send( mn, content )   # call filter e.g.  include_helper_hack( content )  
  end

  # convert light-weight markup to hypertext

  content = text_to_html( content )

  # post-processing

  # make content2 and slide2 available to erb template
    # -- todo: cleanup variable names and use attr_readers for content and slide
  
  if @markup_type == :markdown && config.markdown_post_processing?( @markdown_libs.first ) == false
    puts "  Skipping post-processing (passing content through as is)..."
    @content = content  # content all-in-one - make it available in erb templates
  else
    # sets @content (all-in-one string) and @slides (structured content; split into slides)
    post_processing_slides( content )
  end


  manifest.each do |entry|
    outname = entry[0]
    if outname.include? '__file__' # process
      outname = outname.gsub( '__file__', basename )
      puts "Preparing #{outname}..."

      out = File.new( with_output_path( outname, outpath ), "w+" )

      out << render_template( load_template( entry[1] ), binding )
      
      if entry.size > 2 # more than one source file? assume header and footer with content added inbetween
        out << content2 
        out << render_template( load_template( entry[2] ), binding )
      end

      out.flush
      out.close

    else # just copy verbatim if target/dest has no __file__ in name
      dest   = entry[0]      
      source = entry[1]
            
      puts "Copying to #{dest} from #{source}..."     
      FileUtils.copy( source, with_output_path( dest, outpath ) )
    end
  end

  puts "Done."
end

def load_plugins
    
  patterns = []
  patterns << "#{config_dir}/lib/**/*.rb"
  patterns << 'lib/**/*.rb' unless LIB_PATH == File.expand_path( 'lib' )  # don't include lib if we are in repo (don't include slideshow/lib)
  
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
    
    cmd.on( '-o', '--output PATH', 'Output Path' ) { |s| opts.put( 'output', s ) }

    cmd.on( '-g', '--generate',  'Generate Slide Show Templates (Using Built-In S6 Pack)' ) { opts.put( 'generate', true ) }
    
    cmd.on( "-t", "--template MANIFEST", "Template Manifest" ) do |t|
      # todo: do some checks on passed in template argument
      opts.put( 'manifest', t )
    end

    # ?? opts.on( "-s", "--style STYLE", "Select Stylesheet" ) { |s| $options[:style]=s }
    # ?? opts.on( "--version", "Show version" )  {}
        
    # ?? cmd.on( '-i', '--include PATH', 'Load Path' ) { |s| opts.put( 'include', s ) }

    cmd.on( '-f', '--fetch URI', 'Fetch Templates' ) do |u|
      opts.put( 'fetch_uri', u )
    end
    
    cmd.on( '-c', '--config PATH', 'Configuration Path (default is ~/.slideshow)' ) do |p|
      opts.put( 'config_path', p )
    end
    
    cmd.on( '-l', '--list', 'List Installed Templates' ) { opts.put( 'list', true ) }

    # todo: find different letter for debug trace switch (use v for version?)
    cmd.on( "-v", "--verbose", "Show debug trace" )  do
       logger.datetime_format = "%H:%H:%S"
       logger.level = Logger::DEBUG      
    end
 
    cmd.on_tail( "-h", "--help", "Show this message" ) do
         puts 
         puts "Slide Show (S9) is a free web alternative to PowerPoint or KeyNote in Ruby"
         puts
         puts cmd.help
         puts
         puts "Examples:"
         puts "  slideshow microformats"
         puts "  slideshow microformats.textile         # Process slides using Textile"
         puts "  slideshow microformats.text            # Process slides using Markdown"
         puts "  slideshow microformats.rst             # Process slides using reStructuredText"
         puts "  slideshow -o slides microformats       # Output slideshow to slides folder"
         puts
         puts "More examles:"
         puts "  slideshow -g                           # Generate slide show templates using built-in S6 pack"
         puts
         puts "  slideshow -l                           # List installed slide show templates"
         puts "  slideshow -f s5blank                   # Fetch (install) S5 blank starter template from internet"
         puts "  slideshow -t s5blank microformats      # Use your own slide show templates (e.g. s5blank)"
         puts
         puts "Further information:"
         puts "  http://slideshow.rubyforge.org" 
         exit
    end
  end

  opt.parse!( args )
  
  config.load

  puts "Slide Show (S9) Version: #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"

  if opts.list?
    list_slideshow_templates
  elsif opts.generate?
    create_slideshow_templates
  elsif opts.fetch?
    fetch_slideshow_templates
  else
    load_markdown_libs
    load_plugins  # check for optional plugins/extension in ./lib folder
    
    args.each { |fn| create_slideshow( fn ) }
  end
end

end # class Gen


end # module Slideshow