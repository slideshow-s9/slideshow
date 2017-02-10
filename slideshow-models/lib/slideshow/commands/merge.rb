# encoding: utf-8

module Slideshow


class Merge

  include LogUtils::Logging


  def initialize( config )
    @config  = config
    
    ## todo: check if we need to use expand_path - Dir.pwd always absolute (check ~/user etc.)
    @usrdir = File.expand_path( Dir.pwd )  # save original (current) working directory 
  end

  attr_reader :config
  attr_reader :usrdir   # original working dir (user called slideshow from)


  def merge( deck, ctx, headers, content_for )

    manifestsrc = ctx[:manifestsrc]
    name        = ctx[:name]
    outdir      = ctx[:outdir]
    
    ## note:
    ##   assumes name == basename  (e.g. name without extension and directory)
    ##    rename name to basename - why? why not??
    
    ## note: assumes working directory is (default) work directory
    ##         e.g. original working dir (user called slideshow from)


    puts "Merging slideshow '#{name}'..."
   

  #### pak merge
  #  nb: change cwd to template pak root

  @pakdir = File.dirname( manifestsrc )  # template pak root - make availabe too in erb via binding
  logger.debug " setting pakdir to >#{@pakdir}<"

  #  todo/fix: change current work dir (cwd) in pakman gem itself
  #   for now lets do it here

  logger.debug "changing cwd to pak - new >#{@pakdir}<, old >#{Dir.pwd}<"
  Dir.chdir( @pakdir )


  logger.debug( "manifestsrc >#{manifestsrc}<, outdir >#{outdir}<" )


  ###########################################
  ## setup hash for binding
  assigns = { 'name'    => name,
              'headers' => HeadersDrop.new( headers ), 
              'content' => deck.content,
              'slides'  => deck.slides.map { |slide| SlideDrop.new(slide) },  # strutured content - use LiquidDrop - why? why not?
        }
  
  ## add content_for entries e.g.
  ##    content_for :js  =>  more_content_for_js or content_for_js or extra_js etc.
  ##  for now allow all three aliases

  puts "content_for:"
  pp content_for

  content_for.each do |k,v|
    puts "  (auto-)add content_for >#{k.to_s}< to ctx:"
    puts v
    assigns[ "more_content_for_#{k}"] = v
    assigns[ "content_for_#{k}" ] = v
    assigns[ "extra_#{k}" ] = v
  end
  
  puts "assigns:"
  pp assigns


  Pakman::LiquidTemplater.new.merge_pak( manifestsrc, outdir, assigns, name )


  ## pop/restore org (original) working folder/dir
  unless usrdir == @pakdir
    logger.debug "restoring cwd to usr - new >#{usrdir}<, old >#{Dir.pwd}<"
    Dir.chdir( usrdir )
  end
end # method merge



end # class Merge

end # class Slideshow
