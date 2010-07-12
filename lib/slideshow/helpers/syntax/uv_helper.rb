require 'uv'

module Slideshow
 module Syntax
  module UvHelper

  # uv option defaults
  UV_LANG         = 'ruby'
  UV_LINE_NUMBERS = 'true'
  UV_THEME        = 'amy'

def uv_worker( code, opts )
  
  lang         = opts.fetch( :lang, UV_LANG )  
  line_numbers_value = opts.fetch( :line_numbers, headers.get( 'code-line-numbers', UV_LINE_NUMBERS ))
  line_numbers = (line_numbers_value =~ /true|yes|on/i) ? true : false
  
  # change all-hallows-eve (CSS-style/convention) to all_hallows_eve (uv internal-style)
  theme   = opts.fetch( :theme, headers.get( 'code-theme', UV_THEME )).tr( '-', '_' )
    
  code_highlighted = Uv.parse( code, "xhtml", lang, line_numbers, theme )

  # first time? copy all uv built-in themes (css styles) to temporary cache (~/.slideshow/*)
  uv_first_time = session.fetch( :uv_first_time, true )
  if uv_first_time
    session[ :uv_first_time ] = false
    logger.debug "cache_dir=#{cache_dir}"

    FileUtils.mkdir(cache_dir) unless File.exists?(cache_dir) if cache_dir
    Uv.copy_files "xhtml", cache_dir  
  end
    
  # first time this theme gets used add it to content_for hash for templates to include   
  uv_themes = session[ :uv_themes ] ||= {} 
  if uv_themes[ theme ].nil?
    uv_themes[ theme ] = true
    
    theme_content = File.read( "#{cache_dir}/css/#{theme}.css" )

    theme_out =  %{/* styles for ultraviolet code syntax highlighting theme '#{theme}' */\n\n}
    theme_out << theme_content
    theme_out << %{\n\n}

    content_for( :css, theme_out ) 
  end  

  css_class = 'code'
  css_class_opt = opts.fetch( :class, nil ) #  large, small, tiny, etc.
  css_class << " #{css_class_opt}" if css_class_opt   # e.g. use/allow multiple classes -> code small, code large, etc.
 
  name        = opts.fetch( :name, nil )
  txmt_value  = opts.fetch( :txmt, headers.code_txmt )
  txmt        = (txmt_value =~ /true|yes|on/i) ? true : false
  
  out =  %{<pre class='#{css_class}'>\n}
  out << code_highlighted
  out << %{</pre>\n}
  
  # add optional href link for textmate
  if name
    out << %{<div class="codeurl">}
    out << %{<a href="txmt://open?url=file://#{File.expand_path(name)}">} if txmt  
    out << name
    out << %{</a>} if txmt
    out << %{</div>\n}
  end
  
  return out 
end  

def uv( *args, &blk )   
  # check for optional hash for options
  opts = args.last.kind_of?(Hash) ? args.pop : {}
   
  code = capture_erb(&blk)
  return if code.empty?
    
  code_highlighted = uv_worker( code, opts )
    
  concat_erb( wrap_markup( code_highlighted ), blk.binding )
  return
end  
    
end   # module UvHelper
end  # module Syntax
end # module Slideshow

class Slideshow::Gen
  include Slideshow::Syntax::UvHelper
end