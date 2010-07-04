# builtin text filters
# called before text_to_html
#
# use web filters for processing html/hypertext

module TextFilter

  def comments_percent_style( content )
    # remove comments
    # % comments
    # %begin multiline comment
    # %end multiline comment

    # track statistics
    comments_multi  = 0
    comments_single = 0
    comments_end    = 0

    # remove multi-line comments
    content.gsub!(/^%begin.*?%end/m) do |match|
      comments_multi += 1
      ""
    end
    
     # remove everyting starting w/ %end (note, can only be once in file) 
    content.sub!(/^%end.*/m) do |match|
      comments_end += 1
      ""
    end

    # remove single-line comments    
    content.gsub!(/^%.*/ ) do |match|
      comments_single += 1
      ""
    end
    
    puts "  Removing comments (#{comments_single} %-lines, " +
       "#{comments_multi} %begin/%end-blocks, #{comments_end} %end-blocks)..."
    
    content    
  end

  def skip_end_directive( content )
    # codex-style __SKIP__, __END__ directive
    # ruby note: .*? is non-greedy (shortest-possible) regex match
    content.gsub!(/__SKIP__.*?__END__/m, '')
    content.sub!(/__END__.*/m, '')
    content
  end
  
  def include_helper_hack( content )
    # note: include is a ruby keyword; rename to __include__ so we can use it 
    
    include_counter = 0
    
    content.gsub!( /<%=[ \t]*include/ ) do |match|
      include_counter += 1
      '<%= __include__' 
    end

    puts "  Patching embedded Ruby (erb) code aliases (#{include_counter} include)..."

    content
  end
  
  # allow plugins/helpers; process source (including header) using erb    
  def erb( content )
    puts "  Running embedded Ruby (erb) code/helpers..."
    
    content =  ERB.new( content ).result( binding() )
    content
  end

  def erb_django_style( content )

    # replace expressions (support for single lines only)
    #  {{ expr }}  ->  <%= expr %>
    #  {% stmt %}  ->  <%  stmt %>   !! add in do if missing (for convenience)

    erb_expr = 0
    erb_stmt_beg = 0
    erb_stmt_end = 0

    content.gsub!( /\{\{([^{}\n]+?)\}\}/ ) do |match|
      erb_expr += 1
      "<%= #{$1} %>"
    end

    content.gsub!( /\{%[ \t]*end[ \t]*%\}/ ) do |match|
      erb_stmt_end += 1
      "<% end %>"
    end

    content.gsub!( /\{%([^%\n]+?)%\}/ ) do |match|
      erb_stmt_beg += 1
      if $1.include?('do') 
        "<% #{$1} %>"
      else
        "<% #{$1} do %>"
      end
    end

    puts "  Patching embedded Ruby (erb) code Django-style (#{erb_expr} {{-expressions," +
       " #{erb_stmt_beg}/#{erb_stmt_end} {%-statements)..."
         
    content        
  end

  def code_block_curly_style( content )
    # replace {{{  w/ <pre class='code'>
    # replace }}}  w/ </pre>
    
    # track statistics
    code_begin = 0
    code_end   = 0    
    
    content.gsub!( "{{{{{{", "<pre class='code'>_S9BEGIN_" )
    content.gsub!( "}}}}}}", "_S9END_</pre>" )  
    
    content.gsub!( "{{{" ) do |match|
      code_begin += 1
      "<pre class='code'>"
    end    
    
    content.gsub!( "}}}" ) do |match|
      code_end += 1
      "</pre>"
    end
    
    # restore escaped {{{}}} 
    content.gsub!( "_S9BEGIN_", "{{{" )
    content.gsub!( "_S9END_", "}}}" )
    
    puts "  Patching code blocks (#{code_begin}/#{code_end} {{{/}}}-lines)..."    
    
    content
  end

end

class Slideshow::Gen
  include TextFilter
end