# encoding: utf-8

module Slideshow


class Build
  
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
   
 
  ##
  ##  todo/fix/add:
  ##    allow multiple files
  ##    files get merged together - why? why not? (or processed one-by-one?)
  ##
  ##   check file extension - if css or js than move "verbatim e.g. as-is" to content_for (js,css,etc.)
  ##
  ##


  
  def process_files( args )

     ###
     #  returns a hash of merged buffers e.g.
     #  { text: '...',
     #     js:   '...',
     #     css:  '...',
     #  }
     #  
    
    buffers = {}   
    
    args.each do |fn|

      dirname  = File.dirname( fn )
      basename = File.basename( fn, '.*' )
      extname  = File.extname( fn )
      
      logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

      content = File.read_utf8( fn )

      if extname.downcase == 'css'
        key = :css    # buffer key
      elsif extname.downcase == 'js'
        key = :js
      else  ## assume main text/content
        ##
        ##  todo/check:  process text files with gen(erator) one-by-one later? why? why not?
        #     for now process as one block all together (use sourcedir of first text file)
        key = :text
      end
      
      if buffers[ key ].nil?   ## first entry
        h = { content: content, files: [fn] }
        buffers[ key ] = h
      else                    ## second, third, etc. entry
        h = buffers[ key ]
        h[:content] <<= "\n\n" + content    ## add with (extra) newline
        h[:files]   << fn
      end
    end
  
    buffers
  end # process files

  
  def create_slideshow( arg )

    ## first check if manifest exists / available / valid
    manifestsrc = ManifestFinder.new( config ).find_manifestsrc( config.manifest )


    # expand output path in current dir and make sure output path exists
    @outdir = File.expand_path( config.output_path, usrdir )
    logger.debug "setting outdir to >#{outdir}<"
    FileUtils.makedirs( outdir ) unless File.directory? outdir

    args = [arg]    ## for now for testing always assume array

    buffers = process_files( args )

    puts "buffers:"
    pp buffers

    ## for now use first text file for (auto-)caluclation name and source folder
    fn      = buffers[:text][:files][0]
    content = buffers[:text][:content]


    dirname  = File.dirname( fn )
    basename = File.basename( fn, '.*' )
    extname  = File.extname( fn )
    logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

    # change working dir to sourcefile dir
    # todo: add a -c option to commandline? to let you set cwd?

    @srcdir = File.expand_path( dirname, usrdir )
    logger.debug "setting srcdir to >#{srcdir}<"

    unless usrdir == srcdir    ## use unless cwd/pwd insteadof usrdir - why? why not?
      logger.debug "changing cwd to src - new >#{srcdir}<, old >#{Dir.pwd}<"
      Dir.chdir srcdir
    end

    puts "Preparing slideshow '#{basename}'..."

  
  ###  todo/fix:
  ##  reset headers too - why? why not?
     
  # shared variables for templates (binding)
  @content_for = {}  # reset content_for hash
  # give helpers/plugins a session-like hash
  @session     = {}  # reset session hash for plugins/helpers

  @name        = basename
  @extname     = extname


  ## check for css and js buffers
  ##    todo/fix: check if content_for key is a symbol or just a string !!!!!!
  if buffers[:css]
    @content_for[:css] = buffers[:css][:content].dup    ## add a copy; might get added some more later in-place
  end

  if buffers[:js]
    @content_for[:js] = buffers[:js][:content].dup    ## add a copy; might get added some more later in-place
  end


  gen     = Gen.new( @config,
                     @headers,
                     @session,
                     @content_for )


  ####################
  ## todo/fix: move ctx to Gen.initialize - why? why not?
  gen_ctx = {
    name:    @name,
    extname: @extname,     ### todo/fix: check where is extname used??  why needed? try to remove!!!
    usrdir:  @usrdir,
    outdir:  @outdir,
    srcdir:  @srcdir,
  }

  content = gen.render( content, gen_ctx )
  

  # post-processing (all-in-one HTML with directive as HTML comments)
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
    
  merge_ctx = {
    manifestsrc: manifestsrc,
    outdir:      outdir,
    name:        @name,
  }
  
  merge.merge( deck,
               merge_ctx,
               headers,
               @content_for )


  puts 'Done.'
end # method create_slideshow


end # class Build

end # class Slideshow

