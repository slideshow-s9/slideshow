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
    @hash.has_key?( :fetch_uri ) 
  end
  
  def fetch_uri
    get( 'fetch_uri', '-fetch uri required-' )
  end
  
  def has_includes?
    @hash.has_key?( :include )
  end
  
  def includes
    # fix: use os-agnostic delimiter (use : for Mac/Unix?)
    has_includes? ? @hash[ :include ].split( ';' ) : []
  end
    
  def manifest  
    get( 'manifest', 's6.txt' )
  end
  
  def config_path
    get( 'config_path' )
  end
  
  def output_path
    get( 'output', '.' )
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

end # class Opts

end # module Slideshow
