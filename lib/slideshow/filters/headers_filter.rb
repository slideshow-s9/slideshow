# encoding: utf-8
module Slideshow
  module HeadersFilter

def leading_headers( content_with_headers )
  
  # todo: lets user override headers with command line options
  #  that is, lets you override options using commandline switch
  
  # read source document; split off optional header from source
  # strip leading optional headers (key/value pairs) including optional empty lines

  read_headers = true
  content = ""

  keys = [] # track header keys for stats
  
  content_with_headers.each_line do |line|
    if read_headers && line =~ /^\s*(\w[\w-]*)[ \t]*:[ \t]*(.*)/
      key = $1.downcase
      value = $2.strip
      
      keys << key
    
      logger.debug "  adding header: key=>#{key}< value=>#{value}<"
      headers.put( key, value )
    elsif line =~ /^\s*$/
      content << line  unless read_headers
    else
      read_headers = false
      content << line
    end
  end 

  puts "  Reading #{keys.length} headers: #{keys.join(', ')}..."

  content
end
  
end  # module HeadersFilter
end # module Slideshow

class Slideshow::Gen
  include Slideshow::HeadersFilter
end