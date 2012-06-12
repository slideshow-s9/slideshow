module Slideshow

class Config
  
  def initialize
    # do nothing for now
  end

  def load
    
    # load builtin config file @  <gem>/config/slideshow.yml
    #
    # NB: builtin use a different hierachy (not linked to default/home/user/cli props)
    #     for now builtin has no erb processing
    #     user cannot override builtin settings (only defaults see below)
    props_builtin_file  = File.join( Slideshow.root, 'config', 'slideshow.builtin.yml' )
    @props_builtin = Props.load_file( props_builtin_file )


    props_default_file  = File.join( Slideshow.root, 'config', 'slideshow.yml' )
    @props = @props_default = Props.load_file_with_erb( props_default_file, binding() )

    # check for user settings (slideshow.yml) in home folder
    
    props_home_file = File.join( Env.home, 'slideshow.yml' )
    if File.exists?( props_home_file )
      puts "Loading settings from '#{props_home_file}'..."
      @props = @props_home = Props.load_file_with_erb( props_home_file, binding(), @props )
    end
      
    # check for user settings (slideshow.yml) in working folder
    
    props_work_file = File.join( '.', 'slideshow.yml' )
    if File.exists?( props_work_file )
      puts "Loading settings from '#{props_work_file}'..."
      @props = @props_work = Props.load_file_with_erb( props_work_file, binding(), @props )
    end
  end
    
  def header( key )
    @props.fetch_from_section( 'headers', normalize_key( key ), nil )
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

  def known_markdown_extnames
    ## delegate config to Markdown gem for now
    ## todo/fix: how to pass on setting to Markdown gem??
    Markdown.extnames
  end
  
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
    
    known_textile_extnames + known_markdown_extnames + known_rest_extnames
  end
  
  def text_filters
    @props.fetch( 'filters', [] )
  end
  
  def google_analytics_code
    @props.fetch_from_section( 'analytics', 'google', nil )
  end
  
  def map_fetch_shortcut( key )
    ## todo: normalize key???
    @props.fetch_from_section( 'fetch', key, nil )
  end

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

private

  def normalize_key( key )
    #  make key all lower case/downcase (e.g. Content-Type  => content-type)
    #  replace _ with -                 (e.g. gradient_color => gradient-color)
    #  todo: replace space(s) with -  ??
    #  todo: strip leading and trailing spaces - possible use case ??
    
    key.to_s.downcase.tr( '_', '-' )
  end

end # class Config

end # module Slideshow