module Slideshow

# todo: split (command line) options and headers?
# e.g. share (command line) options between slide shows (but not headers?)

class Headers

  def initialize( config )
    @hash   = {}
    @config = config
  end

  def put( key, value )
    key = normalize_key( key )
    setter = "#{key}=".to_sym

    if respond_to? setter
      send setter, value
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
    value = @config.header( key ) if value.nil?   # try lookup in config properties next
     
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


  DEFAULTS =
  {
    :title             => 'Untitled Slide Show',
    :footer            => '',
    :subfooter         => '',
    :gradient_theme    => 'diagonal',
    :gradient_colors   => 'red orange',

    :code_engine       => 'sh',  # SyntaxHighligher (sh) | ultraviolet (uv) | coderay (cr)
    :code_txmt         => 'false', # Text Mate Hyperlink for Source?
  }

## todo: rename get to fetch??
  def get( key, default=nil )
    key = normalize_key(key)
    value = @hash.fetch( key, DEFAULTS[ key ] )
    if value.nil?
      default
    else
      value
    end
  end

private

  def normalize_key( key )
    key.to_s.downcase.tr('-', '_').to_sym
  end
    
  def get_boolean( key, default )
    key = normalize_key( key )
    value = @hash.fetch( key, DEFAULTS[ key ] )
    if value.nil?
      default
    else
      (value == true || value =~ /true|yes|on/i) ? true : false
    end
  end
  
end  # class Headers


class Opts
  
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
    @config_path
  end
    
  def output_path=(value)
    @output_path = value
  end
  
  def output_path
    @output_path || '.'
  end

end # class Opts

end # module Slideshow