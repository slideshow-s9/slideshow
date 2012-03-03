# encoding: utf-8
module Slideshow
  module DebugFilter

# use it to dump content before erb merge

def dump_content_to_file_debug_text_erb( content )

  return content   unless logger.level == Logger::DEBUG

  outname = "#{@name}.debug.text.erb"

  puts "  Dumping content before erb merge to #{outname}..."

  File.open( outname, 'w' ) do |f|
    f.write( content )	
  end

  content
end

# use it to dump content before html post processing

def dump_content_to_file_debug_html( content )

  return content   unless logger.level == Logger::DEBUG

  outname = "#{@name}.debug.html"

  puts "  Dumping content before html post processing to #{outname}..."

  File.open( outname, 'w' ) do |f|
    f.write( content )	
  end

  content
end

# use it to dump content before text-to-html conversion

def dump_content_to_file_debug_text( content )

  return content   unless logger.level == Logger::DEBUG

  outname = "#{@name}.debug.text"

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
