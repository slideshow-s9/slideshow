module Slideshow

# todo: split (command line) options and headers?
# e.g. share (command line) options between slide shows (but not headers?)

class Opts
  
  def initialize
    @hash = {}
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
  
  def gradient=( value )
    put_gradient( value, :theme, :color1, :color2 )
  end
  
  def gradient_colors=( value )
    put_gradient( value, :color1, :color2 )
  end

  def gradient_color=( value )
    put_gradient( value, :color1 )
  end
  
  def gradient_theme=( value )
    put_gradient( value, :theme )
  end
  
  def []( key )
    value = @hash[ normalize_key( key ) ]
    if value.nil?
      puts "** Warning: header '#{key}' undefined"
      "- #{key} not found -"
    else
      value 
    end
  end

  def generate?
    get_boolean( 'generate', false )
  end
  
  def list?
    get_boolean( 'list', false )
  end
  
  def fetch?
    get( 'fetch_uri', nil ) != nil
  end
  
  def fetch_uri
    get( 'fetch_uri', '-fetch uri required-' )
  end
  
  def has_includes?
    @hash[ :include ]
  end
  
  def includes
    # fix: use os-agnostic delimiter (use : for Mac/Unix?)
    has_includes? ? @hash[ :include ].split( ';' ) : []
  end
    
  def manifest  
    get( 'manifest', 's6.txt' )
  end
  
  def config_path
    get( 'config_path', nil )
  end
  
  def output_path
    get( 'output', '.' )
  end

  def code_engine
    get( 'code-engine', DEFAULTS[ :code_engine ] )
  end
  
  def code_txmt
    get( 'code-txmt', DEFAULTS[ :code_txmt ])
  end


  DEFAULTS =
  {
    :title             => 'Untitled Slide Show',
    :footer            => '',
    :subfooter         => '',
    :gradient_theme    => 'dark',
    :gradient_color1   => 'red',
    :gradient_color2   => 'black',

    :code_engine       => 'uv',  # ultraviolet (uv) | coderay (cr)
    :code_txmt         => 'false', # Text Mate Hyperlink for Source?
  }

  def set_defaults      
    DEFAULTS.each_pair do | key, value |
      @hash[ key ] = value if @hash[ key ].nil?
    end
  end

  def get( key, default )
    @hash.fetch( normalize_key(key), default )
  end

private

  def normalize_key( key )
    key.to_s.downcase.tr('-', '_').to_sym
  end
  
  # Assigns the given gradient-* keys to the values in the given string.
  def put_gradient( string, *keys )
    values = string.split( ' ' )

    values.zip(keys).each do |v, k|
      @hash[ normalize_key( "gradient-#{k}" ) ] = v.tr( '-', '_' )
    end
  end
  
  def get_boolean( key, default )
    value = @hash[ normalize_key( key ) ]
    if value.nil?
      default
    else
      (value == true || value =~ /true|yes|on/i) ? true : false
    end
  end

end # class Opts

end # module Slideshow
