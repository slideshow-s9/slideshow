# builtin text filters
# called before text_to_html
#
# use web filters for processing html/hypertext

module TextFilter

  def skip_end_directive( content )
    # ruby note: .*? is non-greedy (shortest-possible) regex match
    content.gsub!(/__SKIP__.*?__END__/m, '')
    content.sub!(/__END__.*/m, '')
    content
  end
  
  def include_helper_hack( content )
    # note: include is a ruby keyword; rename to __include__ so we can use it 
    content.gsub!( /<%=[ \t]*include/, '<%= __include__' )
    content
  end
  
  # allow plugins/helpers; process source (including header) using erb    
  def erb( content )
    content =  ERB.new( content ).result( binding() )
    content
  end

  def code_block_curly_style( content )
    # o replace {{{  w/ <pre class='code'>
    # o replace }}}  w/ </pre>
    content.gsub!( "{{{{{{", "<pre class='code'>_S9BEGIN_" )
    content.gsub!( "}}}}}}", "_S9END_</pre>" )  
    content.gsub!( "{{{", "<pre class='code'>" )
    content.gsub!( "}}}", "</pre>" )
    # restore escaped {{{}}} I'm sure there's a better way! Rubyize this! Anyone?
    content.gsub!( "_S9BEGIN_", "{{{" )
    content.gsub!( "_S9END_", "}}}" )
    content
  end

end

class Slideshow::Gen
  include TextFilter
end