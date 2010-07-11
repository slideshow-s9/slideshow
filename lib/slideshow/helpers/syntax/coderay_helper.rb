require 'coderay'

module Slideshow
 module Syntax 
  module CodeRayHelper

  # coderay option defaults
  CR_LANG         = 'ruby'
  CR_LINE_NUMBERS = 'table'  # table | list | inline

 def coderay_worker( code, opts )
    
  lang              = opts.fetch( :lang, CR_LANG )
  line_numbers      = opts.fetch( :line_numbers, headers.get('code-line-numbers', CR_LINE_NUMBERS ) ) 
  line_number_start = opts.fetch( :start, nil )
  
  cr_opts = {}
  cr_opts[ :line_numbers ]      = line_numbers.to_sym
  cr_opts[ :line_number_start ] = line_number_start.to_i if line_number_start
   
  # todo: add options for bold_every, tab_width (any others?)
 
  code_highlighted = CodeRay.scan( code, lang.to_sym ).html(cr_opts)

  # first time? get built-in coderay stylesheet
  cr_first_time = session.fetch( :cr_first_time, true )
  if cr_first_time
    session[ :cr_first_time ] = false

    theme_content = CodeRay::Encoders[:html]::CSS.new.stylesheet

    theme_out =  %{/* styles for built-in coderay syntax highlighting theme */\n\n}
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

  out =  %{<div class='CodeRay'>}
  out << %{<pre '#{css_class}'>\n}
  out << code_highlighted
  out << %{</pre>}
  out << %{</div>}

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

def coderay( *args, &blk )
  # check for optional hash for options
  opts = args.last.kind_of?(Hash) ? args.pop : {}
   
  code = capture_erb(&blk)
  return if code.empty?
  
  code_highlighted = coderay_worker( code, opts )
    
  concat_erb( wrap_markup( code_highlighted ), blk.binding )
  return
end

end # module   CodeRayHelper
end # module  Syntax
end # module Slideshow

class Slideshow::Gen
  include Slideshow::Syntax::CodeRayHelper
end