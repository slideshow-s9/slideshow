module Slideshow

class Headers

  def initialize( config )
    @hash   = {}
    @config = config
  end

  ## todo: rename put to store like std hash method
  def put( key, value )
    key = normalize_key( key )
    setter = "#{key}=".to_sym

    if respond_to?( setter )
      send( setter, value )
    else
      @hash[ key ] = value
    end
  end

  def gradient=( line )
    # split into theme (first value) and colors (everything else)
    #  e.g.  diagonal red black
    
    # todo/check: translate value w/ v.tr( '-', '_' ) ??
    
    values = line.split( ' ' )
      
    put( 'gradient-theme', values.first )                 if values.size > 0
    put( 'gradient-colors', values[ 1..-1].join( ' ' ) )  if values.size > 1
  end
  
  def has_gradient?
    # has user defined gradient (using headers)?  (default values do NOT count)
    @hash.has_key?( :gradient_theme ) || @hash.has_key?( :gradient_colors )
  end  
    
  def []( key )
    value = get( key )
     
    if value.nil?
      puts "** Warning: header '#{key}' undefined"
      value = "- #{key} not found -"
    end
    value
  end

  def code_engine
    get( 'code-engine' )
  end
  
  def code_txmt
    get( 'code-txmt' )
  end


## todo: rename get to fetch??
  def get( key, default=nil )
    key = normalize_key(key)
    value = @hash.fetch( key, nil )
    value = @config.header( key ) if value.nil?   # try lookup in config properties next
    if value.nil?
      default
    else
      value
    end
  end

  def get_boolean( key, default )
    value = get( key, default )
    if value.nil?
      default
    else
      (value == true || value =~ /t|true|yes|on/i) ? true : false
    end
  end

private

  def normalize_key( key )
    key.to_s.downcase.tr('-', '_').to_sym
  end
      
end  # class Headers

end # module Slideshow