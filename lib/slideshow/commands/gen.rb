# encoding: utf-8

module Slideshow

## fix:/todo: move generation code out of command into its own class
##   not residing/depending on cli

class Gen     ## todo: rename command to build

  include LogUtils::Logging


  def initialize( config )
    @config  = config
    @headers = Headers.new( config )    

    ## todo: check if we need to use expand_path - Dir.pwd always absolute (check ~/user etc.)
    @usrdir = File.expand_path( Dir.pwd )  # save original (current) working directory 
  end

  attr_reader :usrdir   # original working dir (user called slideshow from)
  attr_reader :srcdir, :outdir    # NB: "initalized" in create_slideshow


  attr_reader :config, :headers
  attr_reader :session      # give helpers/plugins a session-like hash

 
  def guard_text( text )
    # todo/fix 2: note we need to differentiate between blocks and inline
    #   thus, to avoid runs - use guard_block (add a leading newline to avoid getting include in block that goes before)
    
    # todo/fix: remove wrap_markup; replace w/ guard_text
    #   why: text might be css, js, not just html
    
    ###  !!!!!!!!!!!!
    ## todo: add print depreciation warning
    
    wrap_markup( text )
  end

  def guard_block( text )   ## use/rename to guard_text_block - why? why not?
    # wrap in newlines to avoid runons
    "\n\n#{text}\n\n"
  end
  
  def guard_inline( text )   ## use/rename to guard_text_inline - why? why not?
    wrap_markup( text )
  end
   
  def wrap_markup( text )
    # saveguard with wrapper etc./no further processing needed - check how to do in markdown
    text
  end


  def create_slideshow( fn )

    # expand output path in current dir and make sure output path exists
    @outdir = File.expand_path( config.output_path, usrdir )
    logger.debug "setting outdir to >#{outdir}<"
    FileUtils.makedirs( outdir ) unless File.directory? outdir

    dirname  = File.dirname( fn )
    basename = File.basename( fn, '.*' )
    extname  = File.extname( fn )
    logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

    # change working dir to sourcefile dir
    # todo: add a -c option to commandline? to let you set cwd?

    @srcdir = File.expand_path( dirname, usrdir )
    logger.debug "setting srcdir to >#{srcdir}<"

    unless usrdir == srcdir
      logger.debug "changing cwd to src - new >#{srcdir}<, old >#{Dir.pwd}<"
      Dir.chdir srcdir
    end

    puts "Preparing slideshow '#{basename}'..."
   
  ###  todo/fix:
  ##  reset headers too - why? why not?
     
  # shared variables for templates (binding)
  @content_for = {}  # reset content_for hash

  @name        = basename
  @extname     = extname

  @session     = {}  # reset session hash for plugins/helpers

  inname  =  "#{basename}#{extname}"

  logger.debug "inname=#{inname}"
    
  content = File.read_utf8( inname )

  # run text filters
  
  config.text_filters.each do |filter|
    mn = filter.tr( '-', '_' ).to_sym  # construct method name (mn)
    puts "  run filter #{mn}..."
    content = send( mn, content )   # call filter e.g.  include_helper_hack( content )  
  end


  if config.takahashi?
    content = takahashi_slide_breaks( content )
  end


  # convert light-weight markup to hypertext

  content = markdown_to_html( content )


  # post-processing
  deck = Deck.new( content, header_level: config.header_level,
                            use_slide:    config.slide? )




  ## pop/restore org (original) working folder/dir
  unless usrdir == srcdir
    logger.debug "restoring cwd to usr - new >#{usrdir}<, old >#{Dir.pwd}<"
    Dir.chdir( usrdir )
  end

  ## note: merge for now requires resetting to
  ##         original working dir (user called slideshow from)
  merge = Merge.new( config )
  merge.merge( deck,
               outdir,
               headers,
               @name,
               basename,
               @content_for )


  puts 'Done.'
end # method create_slideshow


end # class Gen

end # class Slideshow

