module Slideshow
  module MediawikiEngines

  def mediawiki_to_html( content )    
    puts "  Converting Mediawiki-text (#{content.length} bytes) to HTML..."

    # NB: turn off table_of_contents (TOC) auto-generation with __NOTOC__
    # NB: turn off adding of edit section/markers for headings (noedit:true)

    wiki = WikiCloth::Parser.new( data: "__NOTOC__\n"+content, params: {} )

    content = wiki.to_html( noedit: true )
  end

  end  # module MediawikiEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MediawikiEngines
end
