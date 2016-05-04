# encoding: utf-8

module Slideshow

## fix:/todo: move generation code out of command into its own class
##   not residing/depending on cli

class Gen       ## rename to GenCtx  (Context) - why? why not?

  include LogUtils::Logging


  def initialize( config, headers, session={}, content_for={} )
    @config      = config
    @headers     = headers
    
    @session     = session
    @content_for = content_for
  end

  attr_reader :config, :headers
  attr_reader :session      # give helpers/plugins a session-like hash

  ## todo/check: usrdir needed for something (e.g. why keep it?) - remove? why? why not??
  attr_reader :usrdir   # original working dir (user called slideshow from)
  attr_reader :srcdir, :outdir    # NB: "initalized" in create_slideshow


  def render( content, ctx )
    
    ####################
    ## todo/fix: move ctx to Gen.initialize - why? why not?
    @name     = ctx[:name]
    @extname  = ctx[:extname]

    @outdir   = ctx[:outdir]
    @srcdir   = ctx[:srcdir]
    @usrdir   = ctx[:usrdir]
    
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
    content
  end  # method render



  ###
  # some markdown guard helpers
  #   (e.g. guard text/mark text for do NOT convert)

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


end # class Gen

end # class Slideshow

