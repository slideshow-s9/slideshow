# encoding: utf-8

# builtin text filters
# called before text_to_html
#
# use web filters for processing html/hypertext

module Slideshow
  module TextFilter

  include TextUtils::Filter    # include comments_percent_style, skip_end_directive, etc. filters 


  DIRECTIVES_UNPARSED = [ 'slide', 'style' ]
  DIRECTIVES_RENAMES  = [ 'include', 'class' ]
  DIRECTIVES_EXPRS    = [ 'class', 'clear' ]


def directives_bang_style_to_percent_style( content )

  # for compatibility allow !SLIDE/!STYLE as an alternative to %slide/%style-directive
  
  bang_count = 0

  # get unparsed helpers e.g. SLIDE|STYLE  
  unparsed = DIRECTIVES_UNPARSED.map { |item| item.upcase }.join( '|' )                                                                   
  
  content.gsub!(/^!(#{unparsed})(.*)$/) do |match|
    bang_count += 1
    "<%= #{$1.downcase} '#{$2 ? $2 : ''}' %>"
  end

  puts "  Patching !-directives (#{bang_count} #{DIRECTIVES_UNPARSED.join('/')}-directives)..."

  content
end


def directives_percent_style( content )
        
  directive_unparsed  = 0
  directive_expr      = 0
  directive_block_beg = 0
  directive_block_end = 0

  # process directives (plus skip %begin/%end comment-blocks)

  inside_block  = 0
  inside_helper = false
  
  content2 = ""
  
  content.each_line do |line|
    if line =~ /^%([a-zA-Z][a-zA-Z0-9_]*)(.*)/
      directive = $1.downcase
      params    = $2

      logger.debug "processing %-directive: #{directive}"

      if DIRECTIVES_UNPARSED.include?( directive )   # e.g. slide, style, etc.
        directive_unparsed += 1
        content2 << "<%= #{directive} '#{params ? params : ''}' %>"
      elsif DIRECTIVES_EXPRS.include?( directive )   # e.g. class, clear, etc.
        directive_expr += 1
        content2 << "<%= #{directive} #{params ? erb_simple_params(directive,params) : ''} %>"        
      elsif inside_helper && directive == 'end'
        inside_helper = false
        directive_block_end += 1
        content2 << "%>"        
      elsif inside_block > 0 && directive == 'end'
        inside_block -= 1
        directive_block_end += 1
        content2 << "<% end %>"
      elsif [ 'comment', 'comments', 'begin', 'end' ].include?( directive )  # skip begin/end comment blocks
        content2 << line
      elsif [ 'helper', 'helpers' ].include?( directive )
        inside_helper = true
        directive_block_beg += 1
        content2 << "<%"
      else
        inside_block += 1
        directive_block_beg += 1
        content2 << "<% #{directive} #{params ? erb_simple_params(directive,params) : ''} do %>"
      end
    else
      content2 << line
    end
  end  
    
  puts "  Preparing %-directives (" +
      "#{directive_unparsed} #{DIRECTIVES_UNPARSED.join('/')} directives, " +
      "#{directive_expr} #{DIRECTIVES_EXPRS.join('/')} expr-directives, " +
      "#{directive_block_beg}/#{directive_block_end} block-directives)..."

  content2
end

  ######################
  # todo: fix move to textutils gem (including helpers and config) - why? why not??
  # 


  def erb_rename_helper_hack( content )
    # note: include is a ruby keyword; rename to s9_include so we can use it 
    
    rename_counter = 0
    
    # turn renames into something like:
    #   include|class   etc.
    renames = DIRECTIVES_RENAMES.join( '|' )
    
    content.gsub!( /<%=[ \t]*(#{renames})/ ) do |match|
      rename_counter += 1
      "<%= s9_#{$1}" 
    end

    puts "  Patching embedded Ruby (erb) code for aliases (#{rename_counter} #{DIRECTIVES_RENAMES.join('/')}-aliases)..."

    content
  end
  

end   # module TextFilter
end  # module Slideshow

class Slideshow::Gen
  include Slideshow::TextFilter
end