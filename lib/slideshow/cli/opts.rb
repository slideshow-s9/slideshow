module Slideshow


class Opts

  def header_level=(value)
    @header_level = value.to_i
  end
  
  def header_level
    ## todo: check   0 is not nil?
    @header_level || 1
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


  def quick=(boolean)
    @quick = boolean
  end

  def quick?
    return false if @quick.nil?   # default generate flag is false
    @quick == true
  end

  def quick_manifest=(value)
    @quick_manifest = value
  end
  
  def quick_manifest
    @quick_manifest || 'welcome'
  end


  def plugins=(boolean)
    @plugins = boolean
  end

  def plugins?
    return false if @plugins.nil?   # default generate flag is false
    @plugins == true
  end


  def generate=(boolean)
    @generate = boolean
  end

  def generate?
    return false if @generate.nil?   # default generate flag is false
    @generate == true
  end
  
  def list=(boolean)
    @list = boolean
  end
  
  def list?
    return false if @list.nil?  # default list flag is false
    @list == true
  end

 def fetch_all=(boolean)
    @fetch_all = boolean
  end
  
  def fetch_all?
    return false if @fetch_all.nil?  # default fetch all flag is false
    @fetch_all == true
  end

  def fetch_uri=(value)
    @fetch_uri = value
  end

  def fetch_uri
    @fetch_uri || '-fetch uri required-'
  end
  
  def fetch?
    @fetch_uri.nil? ? false : true
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
    @manifest || 's6'
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