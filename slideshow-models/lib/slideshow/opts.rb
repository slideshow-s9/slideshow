# encoding: utf-8

module Slideshow


class Opts

  def header_level=(value)
    @header_level = value.to_i
  end

  def header_level
    ## todo: check   0 is not nil?
    @header_level || 2        ## note: (new) default is 2  -- note: 2 also breaks on 1
  end

  def slide=(boolean)
    @slide = boolean
  end

  def slide?
    return false if @slide.nil?   # default slide flag is false
    @slide == true
  end

  def takahashi=(boolean)
    @takahashi = boolean
  end

  def takahashi?
    return false if @takahashi.nil?   # default takahashi flag is false
    @takahashi == true
  end

  def verbose=(boolean)   # add: alias for debug ??
    @verbose = boolean
  end

  def verbose?
    return false if @verbose.nil?   # default verbose/debug flag is false
    @verbose == true
  end


  def test=(boolean)
    @test = boolean
  end

  def test?
    return false if @test.nil?   # default verbose/debug flag is false
    @test == true
  end


  def quick_manifest=(value)
    @quick_manifest = value
  end

  def quick_manifest
    @quick_manifest || 'welcome'
  end



  def fetch_all=(boolean)
    @fetch_all = boolean
  end

  def fetch_all?
    return false if @fetch_all.nil?  # default fetch all flag is false
    @fetch_all == true
  end



  def includes=(value)
    @includes = value
  end

  def includes
    # fix: use os-agnostic delimiter (use : for Mac/Unix?)
    @includes.nil? ? [] : @includes.split( ';' )
  end

  def has_includes?
    @includes.nil? ? false : true
  end


  def manifest=(value)
    @manifest = value
  end

  def manifest
    @manifest || 's6blank'
  end


  def config_path=(value)
    @config_path = value
  end

  def config_path
    @config_path || File.join( Env.home, '.slideshow' )
  end

  def output_path=(value)
    @output_path = value
  end

  def output_path
    @output_path || '.'
  end

end # class Opts

end # module Slideshow
