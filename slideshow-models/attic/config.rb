
  def known_extnames
    # returns an array of known file extensions e.g.
    # [ '.textile', '.t' ]
    #
    # using nested key
    # textile:
    #   extnames:  [ .textile, .t ]
    #
    # ruby check: is it better self. ?? or more confusing
    #  possible conflict only with write access (e.g. prop=) 
    
    known_textile_extnames + known_markdown_extnames + known_mediawiki_extnames + known_rest_extnames
  end

  def markdown_post_processing?( lib )
    ## todo: normalize key/lib???
    @props.fetch_from_section( lib, 'post-processing', true )
  end
  
  def known_rest_extnames
    @props.fetch_from_section( 'rest', 'extnames', [] )
  end
  
  def known_textile_extnames
    @props.fetch_from_section( 'textile', 'extnames', [] )
  end

  def known_mediawiki_extnames
    @props.fetch_from_section( 'mediawiki', 'extnames', [] )
  end

  def known_markdown_extnames
    ## delegate config to Markdown gem for now
    ## todo/fix: how to pass on setting to Markdown gem??
    Markdown.extnames
  end


  ###########
  # old directive helpers
  #  e.g. used yaml config
 
#  slideshow.builtin.yml: 
#     ####################
#     ### builtin configuration (not configurable by user now)
#
# helper:
#  unparsed: [ slide, style ]
#  renames: [ include, class ]
#  exprs: [ class, clear ]
  
  def helper_renames
    ## NB: for now user cannot override/extent renames
    @props_builtin['helper']['renames']
  end

  def helper_unparsed
    ## NB: for now user cannot override/extent unparsed helpers
    # use unparsed params (passed along a single string)
    @props_builtin['helper']['unparsed']
  end
  
  def helper_exprs
    ## NB: for now user cannot override/extent helper exprs
    # allow expression as directives (no need for %end block)
    # by default directives are assumed statements (e.g. %mydir  %end)
    @props_builtin['helper']['exprs']
  end


def load
    #
    # NB: builtin use a different hierachy (not linked to default/home/user/cli props)
    #     for now builtin has no erb processing
    #     user cannot override builtin settings (only defaults see below)
    props_builtin_file  = File.join( Slideshow.root, 'config', 'slideshow.builtin.yml' )
    @props_builtin = Props.load_file( props_builtin_file )
    ...
end
   
 
def dump  # dump settings for debugging
    puts "Slideshow settings:"
    @props_builtin.dump  if @props_builtin
    ...
end

