
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

