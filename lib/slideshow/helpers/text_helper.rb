module Slideshow
  module TextHelper
  
def s9_include( name, opts = {} )
  puts "  Including '#{name}'..." 
  content = File.read( name )
end

def help()
  puts "  Adding HTML for Slide Show help instructions..."
    
  text = <<EOS
*Slide Show Keyboard Controls (Help)*

| Action | Key |
| Go to next slide | Space Bar, Right Arrow, Down Arrow, Page Down, Click Heading |
| Go to previous slide | Left Arrow, Up Arrow, Page Up |
| Toggle between slideshow and outline view (&#216;) | T |
| Show/hide slide controls (&#216; &laquo; &raquo;) | C, Move mouse to bottom right corner |
| Zoom in, zoom out, zoom reset (100%)  | Control[@+@]Plus, Control[@+@]Minus, Control[@+@]@0@ |
EOS

 html = <<EOS
<!-- begin help -->
<div class='help projection'>
#{textile_to_html( text )}
</div>
<!-- end help -->
EOS

 guard_block( html )  
end


# Usage example:
#  <%= code 'code/file.rb#section', :lang => 'ruby', :class => 'small' %>
#    or
#  <% code :lang => 'ruby' do %>
#    code goes here
#  <% end %>
#

def code( *args, &blk )
  # check for optional hash for options
  opts = args.last.kind_of?(Hash) ? args.pop : {}
  
  name_plus_part = args.first   # check for optional filename
    
  if name_plus_part 
    name, part = name_plus_part.split( '#' ) # split off optional part/anchor 
    
    content = find_content_from( name, part ) 
    
    # add name and part to opts so engine can use paras too  
    opts[ :name ] = name  
    opts[ :part ] = part if part
    
    return format_code( content, opts )
  elsif blk # inline code via block?
    content = capture_erb(&blk)
    return if content.empty?

    concat_erb( format_code( content, opts ), blk.binding )
    return
  else
    msg = '*** warning: empty code directive; inline code or file para expected'
    puts msg 
    return wrap_markup( "<!-- #{msg} -->" )
  end
end


def find_content_from( name, part )
  begin
    content = File.read( name )

    # note: for now content with no parts selected gets filtered too and (part) marker lines get removed from source
    lines = find_part_lines_in( content, part )

    if part
      puts "  Including code part '#{part}' in '#{name}' [#{lines.size} lines]..."
      ## todo: issue warning if no lines found?
    else
      puts "  Including code in '#{name}' [#{lines.size} lines]..."
    end
  
    return lines.join
  rescue Exception => e
    puts "*** error: reading '#{name}': #{e}"
    exit 2
  end
end

def find_part_lines_in( content, part )
  result = []
  state = part.nil? ? :normal : :skipping 
  content.each_line do |line|
    if line =~ /(START|END):(\w+)/
      if $2 == part
        if $1 == "START"
          state = :normal
        else
          state = :skipping
        end
      end
      next 
    end
    result << line unless state == :skipping
  end
  result
end


def format_code( code, opts )
  
  engine    = opts.fetch( :engine, headers.code_engine ).to_s.downcase  
  
  if engine == 'uv' || engine == 'ultraviolet'
    if respond_to?( :uv_worker )
      code_highlighted = uv_worker( code, opts )
    else
      puts "** error: ultraviolet gem required for syntax highlighting; install with gem install ultraviolet (or use a different engine)"
      exit 2
    end
  elsif engine == 'cr' || engine == 'coderay'
    if respond_to?( :coderay_worker )
      code_highlighted = coderay_worker( code, opts )
    else
      puts "*** error: coderay gem required for syntax highlighting; install with gem install coderay (or use a different engine)"
      exit 2
    end
  else
    method_name = "#{engine}_worker".to_sym
    if respond_to?( method_name )
      # try to call custom syntax highlighting engine
      code_highlighted = send( method_name, code, opts )
    else
      msg = "*** error: unkown syntax highlighting engine '#{engine}'; available built-in options include: uv, ultraviolet, cr, coderay"
      puts msg
      code_highlighted = "<!-- #{msg} -->"
    end
  end
 
  out =  %{<!-- begin code#{opts.inspect} -->\n}
  out << code_highlighted
  out << %{<!-- end code -->\n}
  
  guard_block( out ) # saveguard with notextile wrapper etc./no further processing needed
end


end # module TextHelper
end # module Slideshow

Slideshow::Gen.__send__( :include, Slideshow::TextHelper )