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
  attr_reader :config, :headers
   
   
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
        h = { contents: [content],
              files:    [fn],
            }
        buffers[ key ] = h
      else                    ## second, third, etc. entry
        h = buffers[ key ]
        h[:contents] << content
        h[:files]    << fn
      end
    end
  
    buffers
  end # process files

  
  def create_slideshow( args )

    ## first check if manifest exists / available / valid
    manifestsrc = ManifestFinder.new( config ).find_manifestsrc( config.manifest )


    # expand output path in current dir and make sure output path exists
    outdir = File.expand_path( config.output_path, usrdir )
    logger.debug "setting outdir to >#{outdir}<"
    
    FileUtils.makedirs( outdir ) unless File.directory? outdir


    if args.is_a? String
      args = [args]    ## for now for testing always assume array
    end      
    
    buffers = process_files( args )

    puts "buffers:"
    pp buffers


    ###  todo/fix:
    ##  reset headers too - why? why not?
     
    # shared variables for templates (binding)
    content_for = {}  # reset content_for hash
    # give helpers/plugins a session-like hash
    session     = {}  # reset session hash for plugins/helpers

    name = 'untitled'     ## default name (auto-detect from first file e.g. rest.txt => rest etc.)

    content = ''

    ## check for css and js buffers
    ##    todo/fix: check if content_for key is a symbol or just a string !!!!!!
    if buffers[:css]
      ## concat files (separate with newlines)
      content_for[:css] = buffers[:css][:contents].join( "\n\n" )
    end

    if buffers[:js]
      ## concat files (separate with newlines)
      content_for[:js] = buffers[:js][:contents].join( "\n\n" )
    end


    gen = Gen.new( @config,
                   @headers,
                   session,
                   content_for )

    chunk_size = buffers[:text] ? buffers[:text][:contents].size : 0
    
    (0...chunk_size).each do |i|
      
      chunk   = buffers[:text][:contents][i]
      fn      = buffers[:text][:files][i]

      dirname  = File.dirname( fn )
      basename = File.basename( fn, '.*' )
      extname  = File.extname( fn )
      logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

      ## for now use first text file for (auto-)caluclation name and source folder
      if i==0
        name = basename
        puts "Preparing slideshow '#{basename}'..."
      end

      puts "  [#{i+1}/#{chunk_size}] Generating '#{basename}' (#{dirname})..."


      # change working dir to sourcefile dir
      # todo: add a -c option to commandline? to let you set cwd?

      srcdir = File.expand_path( dirname, usrdir )
      logger.debug "setting srcdir to >#{srcdir}<"
    
      logger.debug "changing cwd to src - new >#{srcdir}<, old >#{Dir.pwd}<"
      Dir.chdir srcdir


      ####################
      ## todo/fix: move ctx to Gen.initialize - why? why not?
      #    move outdir, usrdir, name to Gen.initialize ??
      #    add basename, dirname ?
      gen_ctx = {
        name:    name,
        srcdir:  srcdir,
        outdir:  outdir,
        usrdir:  usrdir,
      }

      chunk = gen.render( chunk, gen_ctx )

      if i==0   ## first chunk
        content << chunk
      else      ## follow-up chunk (start off with two newlines)
        content << "\n\n"
        content << chunk
      end
    end   # each buffer.text.contents


    logger.debug "restoring cwd to usr - new >#{usrdir}<, old >#{Dir.pwd}<"
    Dir.chdir( usrdir )


    # post-processing (all-in-one HTML with directive as HTML comments)
    deck = Deck.new( content, header_level: config.header_level,
                              use_slide:    config.slide? )


  ## note: merge for now requires resetting to
  ##         original working dir (user called slideshow from)
  merge = Merge.new( config )
    
  merge_ctx = {
    manifestsrc: manifestsrc,
    outdir:      outdir,
    name:        name,
  }
  
  merge.merge( deck,
               merge_ctx,
               headers,
               content_for )


  puts 'Done.'
end # method create_slideshow


end # class Build

end # class Slideshow

