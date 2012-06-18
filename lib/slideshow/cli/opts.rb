module Slideshow


class Opts

  def header_level=(value)
    @header_level = value.to_i
  end
  
  def header_level
    ## todo: check   0 is not nil?
    @header_level || 1
  end

  def generate=(value)
    @generate = value
  end

  def generate?
    return false if @generate.nil?   # default generate flag is false
    @generate == true
  end
  
  def list=(value)
    @list = value
  end
  
  def list?
    return false if @list.nil?  # default list flag is false
    @list == true
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
    @manifest || 's6.txt'
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