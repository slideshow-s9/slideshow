require 'redcloth'

Webby::Filters.register :textileplus do |content|
  
  puts 'calling textileplus filter'
  
  # run pre-filters (built-in macros)
  # o replace {{{  w/ <pre class='programlisting'>
  # o replace }}}  w/ </pre>
  content.gsub!( "{{{{{{", "<pre class='programlisting'>_S9BEGIN_" )
  content.gsub!( "}}}}}}", "_S9END_</pre>" )  
  content.gsub!( "{{{", "<pre class='programlisting'>" )
  content.gsub!( "}}}", "</pre>" )
  # restore escaped {{{}}} I'm sure there's a better way! Rubyize this! Anyone?
  content.gsub!( "_S9BEGIN_", "{{{" )
  content.gsub!( "_S9END_", "}}}" )

  red = RedCloth.new( content, [:no_span_caps] )
  red.hard_breaks = false
  content = red.to_html
  
  # html4.01/html5 strict mode 
  # change /> to just >
  #  textile/RedCloth creates <img /> etc. not sure if there's a html output flag/switch
  content.gsub!( "/>", ">" )
  content
end
