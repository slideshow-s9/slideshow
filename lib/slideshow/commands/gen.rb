# encoding: utf-8

module Slideshow

## fix:/todo: move generation code out of command into its own class
##   not residing/depending on cli

class Gen     ## todo: rename command to build

  include LogUtils::Logging

  include ManifestHelper


  def initialize( config )
    @config  = config
    @headers = Headers.new( config )    

    ## todo: check if we need to use expand_path - Dir.pwd always absolute (check ~/user etc.)
    @usrdir = File.expand_path( Dir.pwd )  # save original (current) working directory 
  end

  attr_reader :usrdir   # original working dir (user called slideshow from)
  attr_reader :srcdir, :outdir, :pakdir    # NB: "initalized" in create_slideshow


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

    manifest_path_or_name = config.manifest
    
    # add .txt file extension if missing (for convenience)
    if manifest_path_or_name.downcase.ends_with?( '.txt' ) == false
      manifest_path_or_name << '.txt'
    end
  
    logger.debug "manifest=#{manifest_path_or_name}"
    
    # check if file exists (if yes use custom template package!) - allows you to override builtin package with same name 
    if File.exists?( manifest_path_or_name )
      manifestsrc = manifest_path_or_name
    else
      # check for builtin manifests
      manifests = installed_template_manifests
      matches = manifests.select { |m| m[0] == manifest_path_or_name } 

      if matches.empty?
        puts "*** error: unknown template manifest '#{manifest_path_or_name}'"
        # todo: list installed manifests
        exit 2
      end
        
      manifestsrc = matches[0][1]
    end

    ### todo: use File.expand_path( xx, relative_to ) always with second arg
    ##   do NOT default to cwd (because cwd will change!)
    
    # Reference src with absolute path, because this can be used with different pwd
    manifestsrc = File.expand_path( manifestsrc, usrdir )

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
    
  content = File.read( inname )

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


  ### todo/fix: move merge to its own
  ##     class e.g. commands/merge.rb or something
  ##     or use Merger - why? why not?


  #### pak merge
  #  nb: change cwd to template pak root

  @pakdir = File.dirname( manifestsrc )  # template pak root - make availabe too in erb via binding
  logger.debug " setting pakdir to >#{pakdir}<"

  #  todo/fix: change current work dir (cwd) in pakman gem itself
  #   for now lets do it here

  logger.debug "changing cwd to pak - new >#{pakdir}<, old >#{Dir.pwd}<"
  Dir.chdir( pakdir )


  pakpath     = outdir

  logger.debug( "manifestsrc >#{manifestsrc}<, pakpath >#{pakpath}<" )

  ###########################################
  ## fix: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ## todo: setup hash for binding
  ctx = { 'name'    => @name,
          'headers' => HeadersDrop.new( @headers ), 
          'content' => deck.content,
          'slides'  => deck.slides.map { |slide| SlideDrop.new(slide) },  # strutured content - use LiquidDrop - why? why not?
          ## todo/fix: add content_for hash
          ## and some more -- ??
        }
  
  ## add content_for entries e.g.
  ##    content_for :js  =>  more_content_for_js or content_for_js or extra_js etc.
  ##  for now allow all three aliases

  puts "content_for:"
  pp @content_for

  @content_for.each do |k,v|
    puts "  (auto-)add content_for >#{k.to_s}< to ctx:"
    puts v
    ctx[ "more_content_for_#{k}"] = v
    ctx[ "content_for_#{k}" ] = v
    ctx[ "extra_#{k}" ] = v
  end
  
  puts "ctx:"
  pp ctx


  Pakman::LiquidTemplater.new.merge_pak( manifestsrc, pakpath, ctx, basename )

  logger.debug "restoring cwd to src - new >#{srcdir}<, old >#{Dir.pwd}<"
  Dir.chdir( srcdir )

  ## pop/restore org (original) working folder/dir
  unless usrdir == srcdir
    logger.debug "restoring cwd to usr - new >#{usrdir}<, old >#{Dir.pwd}<"
    Dir.chdir( usrdir )
  end

  puts "Done."
end # method create_slideshow


end # class Gen

end # class Slideshow