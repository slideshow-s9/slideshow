

# add slide directive before div h1 (for pandoc-generated html)
#
# e.g. changes:
# <div id='header'>
# <h1 id='optional' class='optional'>
#  to
#  html comment -> _S9SLIDE_ 
# <div id='header'>
# <h1 id='optional' class='optional'>


def add_slide_directive_before_div_h1( content )

  slide_count = 0

  content = content.gsub( /<div[^>]*>\s*<h1/ ) do |match|
    slide_count += 1
    "\n<!-- _S9SLIDE_ -->\n#{Regexp.last_match(0)}" 
  end

  puts "  Adding #{slide_count} slide breaks (using div_h1 rule)..."

  content
end
