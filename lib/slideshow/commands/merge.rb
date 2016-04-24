# encoding: utf-8

module Slideshow


class Merge

  include LogUtils::Logging

  include ManifestHelper


  def initialize( config )
    @config  = config
    
    ## todo: check if we need to use expand_path - Dir.pwd always absolute (check ~/user etc.)
    @usrdir = File.expand_path( Dir.pwd )  # save original (current) working directory 
  end

  attr_reader :config
  attr_reader :usrdir   # original working dir (user called slideshow from)


  def merge( deck, outdir, headers, name, basename, content_for ) 
    ## note: assumes working directory is (default) work directory
    ##         e.g. original working dir (user called slideshow from)

    manifestsrc = find_manifestsrc()

    puts "Merging slideshow '#{basename}'..."
   

  #### pak merge
  #  nb: change cwd to template pak root

  @pakdir = File.dirname( manifestsrc )  # template pak root - make availabe too in erb via binding
  logger.debug " setting pakdir to >#{@pakdir}<"

  #  todo/fix: change current work dir (cwd) in pakman gem itself
  #   for now lets do it here

  logger.debug "changing cwd to pak - new >#{@pakdir}<, old >#{Dir.pwd}<"
  Dir.chdir( @pakdir )


  pakpath     = outdir

  logger.debug( "manifestsrc >#{manifestsrc}<, pakpath >#{pakpath}<" )

  ###########################################
  ## fix: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ## todo: setup hash for binding
  ctx = { 'name'    => name,
          'headers' => HeadersDrop.new( headers ), 
          'content' => deck.content,
          'slides'  => deck.slides.map { |slide| SlideDrop.new(slide) },  # strutured content - use LiquidDrop - why? why not?
          ## todo/fix: add content_for hash
          ## and some more -- ??
        }
  
  ## add content_for entries e.g.
  ##    content_for :js  =>  more_content_for_js or content_for_js or extra_js etc.
  ##  for now allow all three aliases

  puts "content_for:"
  pp content_for

  content_for.each do |k,v|
    puts "  (auto-)add content_for >#{k.to_s}< to ctx:"
    puts v
    ctx[ "more_content_for_#{k}"] = v
    ctx[ "content_for_#{k}" ] = v
    ctx[ "extra_#{k}" ] = v
  end
  
  puts "ctx:"
  pp ctx


  Pakman::LiquidTemplater.new.merge_pak( manifestsrc, pakpath, ctx, basename )


  ## pop/restore org (original) working folder/dir
  unless usrdir == @pakdir
    logger.debug "restoring cwd to usr - new >#{usrdir}<, old >#{Dir.pwd}<"
    Dir.chdir( usrdir )
  end
end # method merge


private

  def find_manifestsrc    ## rename - just use find_manifest ??
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
    manifestsrc
  end


end # class Merge

end # class Slideshow
