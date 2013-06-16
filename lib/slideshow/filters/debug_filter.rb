# encoding: utf-8
module Slideshow
  module DebugFilter

# use it to dump content before erb merge

def dump_content_to_file_debug_text_erb( content )

  # NB: using attribs from mixed in class
  #   - opts
  #   - outdir

  return content   unless opts.verbose?

  outname = "#{outdir}/#{@name}.debug.text.erb"

  puts "  Dumping content before erb merge to #{outname}..."

  File.open( outname, 'w' ) do |f|
    f.write( content )
  end

  content
end

# use it to dump content before html post processing

def dump_content_to_file_debug_html( content )

  # NB: using attribs from mixed in class
  #   - opts
  #   - outdir

  return content   unless opts.verbose?

  outname = "#{outdir}/#{@name}.debug.html"

  puts "  Dumping content before html post processing to #{outname}..."

  File.open( outname, 'w' ) do |f|
    f.write( content )
  end

  content
end

# use it to dump content before text-to-html conversion

def dump_content_to_file_debug_text( content )

  # NB: using attribs from mixed in class
  #   - opts
  #   - outdir

  return content   unless opts.verbose?

  outname = "#{outdir}/#{@name}.debug.text"

  puts "  Dumping content before text-to-html conversion to #{outname}..."

  File.open( outname, 'w' ) do |f|
    f.write( content )
  end

  content

end
  
end  # module DebugFilter
end # module Slideshow

class Slideshow::Gen
  include Slideshow::DebugFilter
end
