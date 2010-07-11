module Slideshow
  module SourceHelper


def source( *args )

 # make everyting optional; use it like: 
 #   source( name_or_path, opts={} )

 # check for optional hash for options
 opts = args.last.kind_of?(Hash) ? args.pop : {}

 # check for optional name or path
 name_or_path = args.last.kind_of?(String) ? args.pop : "#{@name}#{@extname}" 

 link_text   = opts[:text] || '(Source)' 
 
 # add extra path (e.g. 3rd) if present
 name_or_path = "#{opts[:path]}/#{name_or_path}"   if opts[:path]
 
 # add file extension if missing (for convenience)
 name_or_path << @extname   if File.extname( name_or_path ).empty?

  base = 'http://github.com/geraldb/slideshow/raw/master/samples'

  buf = "<a href='#{base}/#{name_or_path}'>#{link_text}</a>"
  
  puts "  Adding HTML for source link to '#{name_or_path}'..."      
  
  guard_inline( buf )      
end
    
  
end # module SourceHelper
end # module Slideshow

class Slideshow::Gen
  include Slideshow::SourceHelper
end
